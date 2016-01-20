import SPARQLWrapper
import re

endpoint = SPARQLWrapper.SPARQLWrapper("http://virtuoso.clariah-sdh.eculture.labs.vu.nl/sparql")

# w/o count query is very slow
endpoint.setQuery("""
    SELECT ?graph COUNT(*) AS ?triples 
    WHERE { 
        GRAPH ?graph {?s ?p ?o}
    }
    ORDER BY DESC(?triples)
""")
endpoint.setReturnFormat(SPARQLWrapper.JSON)
results = endpoint.query().convert()

graphs_01_19 = []
for result in results['results']["bindings"]:
    x = result['graph']['value']
    if re.search("01-19", x): # could also filter in query, but seems very slow
        graphs_01_19.append(x)

# test on one graph
querystring = "CLEAR GRAPH <%s>" % graphs_01_19[0]
endpoint.setQuery(querystring)
endpoint.query()

for graph in graphs_01_19:
    querystring = "CLEAR GRAPH <%s>" % graph
    endpoint.setQuery(querystring)
    endpoint.query()