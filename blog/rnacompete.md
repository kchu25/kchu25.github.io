@def title = "Download and process RNAcompete data"
@def published = "11 September 2025"
@def tags = ["computational-biology", "bioinformatics"]


## Download and process RNAcompete data

### Why do we care?
RNAcompete, or the "RNA version of Protein Binding Microarrays," is a high-throughput method to measure the binding affinity of RNA-binding proteins (RBPs). Its data can be intuitively understood as a matrix:
$$
    \Abm = \begin{pmatrix} 
    a_{11} & a_{12} & \cdots & a_{1m} \\ 
    a_{21} & a_{22} & \cdots & a_{2m} \\
    \vdots & \vdots & \ddots & \vdots \\
    a_{n1} & a_{n2} & \cdots & a_{nm}
    \end{pmatrix}
$$
where each component $a_{ij}$ ​records a quantitative measure (the binding affinity) of how strongly the $i$-th RNA sequence binds to the $j$-th RBP. In my opinion, this setup is incredibly powerful, because it naturally allows us to model the binding sites as a *regression* problem (i.e. supervised learning). The throughput, i.e. the large number of sequences (rows), is also very important because it allows the model to learn from a diverse range of successes and failures. 

While slightly dated compared to many of today’s hot topics in genomics, I think it’s still worth taking a closer look at how to work with this kind of data.

### Let's do this

The RNAcompete data is located at NCBI: 

- [https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE41235](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE41235)

To process RNAcompete data, we will use the [family of files](https://ftp.ncbi.nlm.nih.gov/geo/series/GSE41nnn/GSE41235/miniml/) formatted in [MINiML](https://www.ncbi.nlm.nih.gov/geo/info/MINiML.html). Throughout this we'll use the Julia programming language.

By inspecting the files in this family, we can make a few observations:
- The file `GSE41235_family.xml` contains the metadata of the GEO MINiML dataset for the RNAcompete experiments.
- The file `GPL16119-tbl-1.txt` contains tab-delimited probe information, including sequences and their corresponding identifiers.
    - Each sequence is assigned with an identifier in the form `RBD_v3_xxxxxx`.
- The files `GSM1011563-tbl-1.txt`, ..., `GSM1138966-tbl-1.txt` (244 of them) are the binding affinity measurements for each of the RBP.
    - Each RBP is assigned with an identifier in the form `GSMxxxxxxx`.
    - Each `GSMxxxxxxx-tbl-1.txt` contain a list of affinity measurement quantities, with each quantity corresponding to a sequence identifier.

Hence we can roughly see that there are three things to do to process this data:
1. Map the correspondence between RBP identifiers and RBP names by creating a list of tuples `(GSMxxxxx, RBP name)`.
2. Map the correspondence between sequence identifiers and sequences by creating a list of tuples `(RBD_vc_xxxxxx, sequence)`.
3. Create a matrix where rows correspond to different sequences and columns correspond to different RBPs.

---
Let's start with the first part. The goal here is to create a dictionary where the key–value pairs are of the form `(RBP-idenfiers, RBP)`. The following code works on the `GSE41235_family.xml` to accomplish this. 
End result is a dict called `dict_rbp`.

````julia
using EzXML
using DataFrames
# Correct way to read XML from file
doc = EzXML.readxml("GSE41235_family.xml")  # This is the correct function
root_ = doc.root

# Prints the name of the root XML element
println("Root element: ", root_.name)
# Counts and prints how many direct child elements the root has
println("Number of child elements: ", length(elements(root_)))
# Uses XPath to find ALL elements in the entire XML document 
all_elements = EzXML.findall("//*", root_)  # XPath first, then element
# Creates an array of all element names from the document and removes duplicates
[elem.name for elem in all_elements] |> unique

# Creates a dictionary mapping "x" to the GEO MINiML XML namespace URL.
ns = Dict("x" => "http://www.ncbi.nlm.nih.gov/geo/info/MINiML")
# Finds all Sample elements in the XML document using the defined namespace.
samples = EzXML.findall("//x:Sample", root_, ns)
#  Initializes an empty array to store the extracted accession and RBP data pairs.
accession_and_rbp = []

for s in samples
    # Finds all child elements within the current sample element.
    all_elems_under_sample = EzXML.findall(".//*", s, ns)
    # Extracts the accession number from the 6th child element.
    accession = nodecontent(all_elems_under_sample[6])
    # Extracts and strips whitespace from the RBP name in the 14th child element.
    rbp = nodecontent(all_elems_under_sample[14]) |> strip
    push!(accession_and_rbp, (accession=accession, rbp=rbp))
end


df = DataFrame(accession_and_rbp) # just for the view
dict_rbp = Dict(i.accession => i.rbp for i in accession_and_rbp)
````


Next, we map the sequence identifiers to their corresponding sequences. The file `GPL16119-tbl-1.txt` contains several columns, ordered as follows:
1. `Unique probe identifier`,
1. `Array spot row number`,
1. `Array spot column number`,
1. `Unique probe identifier`,
1. `Spot type (custom designed)`,
1. `3'- to 5'- DNA sequence of microarray probe`,
1. `5'- to 3'- Sequence of RNA hybridized to micrarray probe`,
1. `Structure of RNA in bracket notation`,
1. `Mean free energy of RNA sequence`

From these, columns 1 and 7 are the ones we want to extract. The following code accomplishes this by building a dictionary, `dict_seq`, 

And therefore column 1 and 7 are the ones we want to extract. The following code will get the job done, to get the correspondence as a dict `dict_seq`, where each key–value pair has the form `(Sequence-identifier, sequence)`.
```
using CSV
f = CSV.read("GPL16119-tbl-1.txt", 
    DataFrame; delim='\t', ignorerepeated=true, header=false)

dict_seq = Dict(i => j for (i, j) in 
    zip(f.Column1, f.Column7))
```

Next, we map the affinities of each RBP to their corresponding sequences and store the results in a matrix. This is done as follows:

```julia
# Initializes a 2D array to hold affinity values, filled with NaN.
affinities = fill(NaN, (length(keys(dict_seq)), length(dict_rbp)))

rbp_affinity_files = filter(x->startswith(x, "GSM"), readdir("./"))

for (column_index, rbp_affinity_file) in enumerate(rbp_affinity_files)

    @info "Processing column: $column_index"
    # read the affinity file    
    df = CSV.read(rbp_affinity_file, DataFrame; 
        delim='\t', ignorerepeated=true, header=false, types=String)  
    # forces all columns to be read as strings
    # make a dict of sequence identifier to affinity
    dict_affinity = Dict(
        i => ismissing(j) || j=="null" ? NaN : parse(Float64, String(j)) 
        for (i, j) in zip(df.Column1, df.Column2))
    # get the file's RBP identifier
    rbp_identifier = split(rbp_affinity_file, "-")[1]

    # loop through each of the sequence
    for (row_index, seq_identifier) in enumerate(keys(dict_seq))
        # get the affinity
        affinities[row_index, column_index] = 
            get(dict_affinity, seq_identifier, NaN) # if not found, return NaN  
    end
end
```

Finally, we create ordered arrays for the RBP names and sequences, corresponding to the matrix columns and rows:

```julia
# Extract RBP identifiers from filenames
rbp_identifiers = split.(rbp_affinity_files, "-") .|> first

# Get RBP names in the same order as the matrix columns
rbps = [dict_rbp[i] for i in rbp_identifiers]

# Get sequences in the same order as the matrix rows
seqs = [dict_seq[i] for i in keys(dict_seq)]
```

This creates three aligned data structures:
- `affinities`: A matrix where `affinities[i,j]` contains the binding affinity of sequence `i` to RBP `j`
- `seqs`: An array where `seqs[i]` contains the RNA sequence corresponding to matrix row `i`
- `rbps`: An array where `rbps[j]` contains the RBP name corresponding to matrix column `j`

The result is a complete dataset ready for downstream analysis, with all binding affinity measurements organized in a structured matrix format alongside the corresponding sequence and protein annotations.

Caveats:
- Not all RNA sequences are of the same length, so further processing may be required.
- Some values are missing; these have been filled in as NaNs in the affinity matrix.


#### References

{{show_refs ray2017rnacompete}}