using Dates
using BibTeX

function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
end

"""
    {{blogposts}}

Plug in the list of blog posts contained in the `/blog/` folder.
"""
@delay function hfun_blogposts()
    today = Dates.today()
    curyear = year(today)
    curmonth = month(today)
    curday = day(today)

    list = readdir("blog")
    filter!(f -> endswith(f, ".md"), list)
    sorter(p) = begin
        ps  = splitext(p)[1]
        url = "/blog/$ps/"
        surl = strip(url, '/')
        pubdate = pagevar(surl, :published)
        if isnothing(pubdate)
            return Date(Dates.unix2datetime(stat(surl * ".md").ctime))
        end
        return Date(pubdate, dateformat"d U Y")
    end
    sort!(list, by=sorter, rev=true)

    io = IOBuffer()
    write(io, """<ul class="blog-posts">""")
    for (i, post) in enumerate(list)
        if post == "index.md"
            continue
        end
        ps  = splitext(post)[1]
        write(io, "<li><span><i>")
        url = "/blog/$ps/"
        surl = strip(url, '/')
        title = pagevar(surl, :title)
        pubdate = pagevar(surl, :published)
        if isnothing(pubdate)
            date    = "$curyear-$curmonth-$curday"
        else
            date    = Date(pubdate, dateformat"d U Y")
        end
        write(io, """$date  </i></span>&emsp;<a href="$url">$title</a>""")
    end
    write(io, "</ul>")
    return String(take!(io))
end

"""
    {{custom_taglist}}

Plug in the list of blog posts with the given tag
"""
function hfun_custom_taglist()::String
    tag = locvar(:fd_tag)
    rpaths = globvar("fd_tag_pages")[tag]
    sorter(p) = begin
        pubdate = pagevar(p, :published)
        if isnothing(pubdate)
            return Date(Dates.unix2datetime(stat(p * ".md").ctime))
        end
        return Date(pubdate, dateformat"d U Y")
    end
    sort!(rpaths, by=sorter, rev=true)

    io = IOBuffer()
    write(io, """<ul class="blog-posts">""")
    # go over all paths
    for rpath in rpaths
        write(io, "<li><span><i>")
        url = get_url(rpath)
        title = pagevar(rpath, :title)
        pubdate = pagevar(rpath, :published)
        if isnothing(pubdate)
            date    = "$curyear-$curmonth-$curday"
        else
            date    = Date(pubdate, dateformat"d U Y")
        end
        # write some appropriate HTML
        write(io, """$date</i></span><a href="$url">$title</a>""")
    end
    write(io, "</ul>")
    return String(take!(io))
end


# BibTeX stuff

function ref_item(ref, infos)
    io = IOBuffer()

    author = infos["author"]
    author_last, author_first = strip.(split(author, ","))

    write(io, "<li id=\"#$ref\">")
    write(io, """$author_first $author_last, <span style="font-style:italic;">$(infos["title"])</span>, $(infos["year"]).""")
    write(io, "</li>")
    return String(take!(io))
end


function hfun_show_refs(refs)
    _, allrefs = parse_bibtex(read(joinpath("_assets", "bibex.bib"), String))
    out = IOBuffer()
    write(out, "<ul>")
    for ref in refs
        infos = get(allrefs, ref, nothing)
        isnothing(infos) && continue
        write(out, ref_item(ref, infos))
    end
    write(out, "</ul>")
    return String(take!(out))
end

"""
    {{citation_box}}

Generate a citation box for the current blog post.
"""
function hfun_citation_box()
    # Get page variables
    title = locvar(:title)
    authors = locvar(:authors)
    published_date = locvar(:published)
    citation_author = locvar(:citation_author)
    citation_title = locvar(:citation_title)
    
    # Default values if not set
    authors = isnothing(authors) ? ["Shane Chu"] : authors
    citation_author = isnothing(citation_author) ? "Chu, Shane" : citation_author
    citation_title = isnothing(citation_title) ? title : citation_title
    
    # Get current page URL
    current_path = locvar(:fd_rpath)
    base_url = globvar("website_url")
    full_url = base_url * current_path
    
    # Parse date
    if !isnothing(published_date)
        date_obj = Date(published_date, dateformat"d U Y")
        year = Dates.year(date_obj)
        formatted_date = Dates.format(date_obj, dateformat"Y/m/d")
    else
        year = Dates.year(Dates.today())
        formatted_date = Dates.format(Dates.today(), dateformat"Y/m/d")
    end
    
    io = IOBuffer()
    write(io, """<div class="citation-box">""")
    write(io, """<h4>Citation</h4>""")
    
    # APA Style
    write(io, """<p><strong>APA:</strong><br>""")
    write(io, """$citation_author ($year). <em>$citation_title</em>. Shane Chu's Blog. <a href="$full_url">$full_url</a></p>""")
    
    # BibTeX
    # Create a simple key from title
    title_words = split(title)
    key_words = title_words[1:min(3, length(title_words))]
    bibtex_key = replace(lowercase(join(key_words, "")), " " => "")
    bibtex_key = "chu$(year)$(bibtex_key)"
    
    write(io, """<p><strong>BibTeX:</strong></p>""")
    write(io, """<pre><code>@misc{$bibtex_key,
  author = {$(join(authors, " and "))},
  title = {$title},
  howpublished = {\\url{$full_url}},
  year = {$year},
  note = {Accessed: $(Dates.format(Dates.today(), dateformat"Y-m-d"))}
}</code></pre>""")
    
    write(io, """</div>""")
    return String(take!(io))
end

"""
    {{citation_metadata}}

Generate HTML meta tags for citation metadata (Dublin Core, Google Scholar, etc.)
"""
function hfun_citation_metadata()
    title = locvar(:title)
    authors = locvar(:authors)
    published_date = locvar(:published)
    doi = locvar(:doi)
    
    # Default values
    authors = isnothing(authors) ? ["Shane Chu"] : authors
    
    # Get current page URL
    current_path = locvar(:fd_rpath)
    base_url = globvar("website_url")
    full_url = base_url * current_path
    
    # Parse date
    if !isnothing(published_date)
        date_obj = Date(published_date, dateformat"d U Y")
        iso_date = Dates.format(date_obj, dateformat"Y-m-d")
    else
        iso_date = Dates.format(Dates.today(), dateformat"Y-m-d")
    end
    
    io = IOBuffer()
    
    # Dublin Core metadata
    write(io, """<meta name="DC.Title" content="$title">""")
    for author in authors
        write(io, """<meta name="DC.Creator" content="$author">""")
    end
    write(io, """<meta name="DC.Date" content="$iso_date">""")
    write(io, """<meta name="DC.Identifier" content="$full_url">""")
    write(io, """<meta name="DC.Publisher" content="Shane Chu">""")
    write(io, """<meta name="DC.Type" content="Text">""")
    write(io, """<meta name="DC.Format" content="text/html">""")
    
    # Google Scholar metadata
    write(io, """<meta name="citation_title" content="$title">""")
    for author in authors
        write(io, """<meta name="citation_author" content="$author">""")
    end
    write(io, """<meta name="citation_publication_date" content="$iso_date">""")
    write(io, """<meta name="citation_journal_title" content="Shane Chu's Blog">""")
    write(io, """<meta name="citation_publisher" content="Shane Chu">""")
    
    if !isnothing(doi) && !isempty(doi)
        write(io, """<meta name="citation_doi" content="$doi">""")
    end
    
    # Open Graph metadata for social sharing
    write(io, """<meta property="og:title" content="$title">""")
    write(io, """<meta property="og:type" content="article">""")
    write(io, """<meta property="og:url" content="$full_url">""")
    write(io, """<meta property="article:author" content="$(join(authors, ", "))">""")
    write(io, """<meta property="article:published_time" content="$iso_date">""")
    
    return String(take!(io))
end
