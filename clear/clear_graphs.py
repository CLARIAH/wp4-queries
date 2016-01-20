from SPARQLWrapper import SPARQLWrapper, POST, JSON
import re
import time 

endpoint = SPARQLWrapper("http://virtuoso.clariah-sdh.eculture.labs.vu.nl/sparql")


# w/o count query is very slow
endpoint.setQuery("""
    SELECT DISTINCT ?graph COUNT(*) AS ?triples 
    WHERE { 
        GRAPH ?graph {?s ?p ?o}
    }
    ORDER BY ?graph
""")

endpoint.setReturnFormat(JSON)
results = endpoint.query().convert()

graphs = []
for result in results['results']["bindings"]:
    graph = result['graph']['value']
    if re.search("2016-01-20", graph): # could also filter in query, but seems very slow
        graphs.append(graph)

# querystring = "CLEAR GRAPH <%s>" % graphs_01_19[0]
# endpoint.setQuery(querystring)
# endpoint.query()

for graph in graphs:
    print graph 
    querystring = "CLEAR GRAPH <%s>" % graph
    endpoint.setQuery(querystring)
    endpoint.setMethod(POST)
    endpoint.query()
    time.sleep(5) 