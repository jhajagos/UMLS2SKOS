import networkx as nx
import collections
import Queue
import csv

def calc_root(G):
    all_pairs_G=nx.all_pairs_dijkstra_path_length(G)
    root=""
    maxi=0
    for x in all_pairs_G.keys():
        for y in all_pairs_G[x].keys():
                
                if(all_pairs_G[x][y] > maxi):
                    maxi=all_pairs_G[x][y]
                    root=y
    return root   


def impregnate_height(G,root):
    Graph_adj_list=collections.defaultdict(list)
    Graph_nodes=G.nodes(data=True) 
    for x in Graph_nodes:
        x[1]['depth']=None
    G.node[root]['depth']= 0
    Graph_edges=G.edges()
    for x in Graph_edges:
        Graph_adj_list[x[1]].append(x[0])
    q= Queue.Queue(maxsize=250000)
    q.put(root)
    count=1
    while( not q.empty()):
        active=q.get()
        temp_list=Graph_adj_list[active]
        for x in temp_list:
            if G.node[x]['depth']== None:
                G.node[x]['depth']=G.node[active]['depth']+1
                q.put(x)
                count=count+1             
    return count

print "Select 2 Graphml file you want to combine - Traversal will happen from 2nd to root of 1st "
    
G=nx.Graph()
file_name=raw_input("Enter the first file name with full path if not in same folder \n")
G1=nx.read_graphml(file_name)
file_name=raw_input("Enter the second file name with full path if not in same folder \n")
G2=nx.read_graphml(file_name)

#################################################################
#Adds Prefix to nodes to avoid naming conflicts for future combining
prefix_1=raw_input("Enter prefix for 1st graph (3 letter with ' - ' Eg. icd- ) \n")
G1=nx.union(G1, G, rename=(prefix_1,"G-1"))
prefix_2=raw_input("Enter prefix for 2nd graph (3 letter with ' - ' Eg. icd-) \n")
G2=nx.union(G2, G, rename=(prefix_2,"G-1"))



#################################################################
# Calculates the root of each taxonomy 
root_1 = calc_root(G1)
root_2 = calc_root(G2)
print ("Root of 1st Taxonomy",root_1)
print ("Root of 2nd Taxonomy",root_2)

#################################################################
# Impregnates height attribute into graphml calculated from the root
count_1=impregnate_height(G1,root_1)
print (" Nodes in 1st Graph =",count_1)
count_2=impregnate_height(G2,root_2)
print (" Nodes in 2nd Graph =",count_2)
print "----------------------------------------------"
print ("Total Node to be processed",count_1+count_2)

#####################################################                    

Combo_Graph=nx.union(G1,G2)            
nodes_cui_dict_G1=nx.get_node_attributes(G1,'CUI')
nodes_G1=G1.nodes()
nodes_cui_dict_G2=nx.get_node_attributes(G2,'CUI')
nodes_G2=G2.nodes()


count =0            
shared_cui={}

for x in nodes_G2:
    for y in nodes_G1:
        if(nodes_cui_dict_G1[y] == nodes_cui_dict_G2[x] ):
            Combo_Graph.add_edge(x,y)      
    count=count+1
    if (count%500 == 0) :
        print (count, " nodes processed out of ",count_2)        
            
op_file=raw_input("Enter output file name with .csv suffix \n");            
f=open(op_file,'wb')
writer = csv.writer(f, delimiter=',',quotechar='"', quoting=csv.QUOTE_MINIMAL)

start=None
end=None
spl=nx.all_pairs_dijkstra_path(Combo_Graph)
Combo_Nodes=Combo_Graph.nodes(data=True)
temp=[]
temp.append('Start_Label')
temp.append('Start_code') 
temp.append('Start_CUI')
temp.append('Start_depth')
temp.append('Pre_Trans_Label')
temp.append('Pre_Trans_code') 
temp.append('Pre_Trans_CUI')
temp.append('Pre_Trans_depth')
temp.append('Post_Trans_Label')
temp.append('Post_Trans_code')
temp.append('Post_Trans_CUI')
temp.append('Post_Trans_depth')
writer.writerow(temp)
c=0
for x in spl.keys(): 
    temp=[]
    count=0
    
    if x[:4]==prefix_2:
        for y in spl[x].keys():
            if y==root_1:
                    start=x
                    end=y
                    for h in Combo_Nodes:
                        if h[0] == start:
                            start_node=h
                        if h[0] == end:
                            end_node=h  
                    temp.append(start_node[1]['Label'])
                    temp.append(start_node[1]['code']) 
                    temp.append(start_node[1]['CUI'])
                    temp.append(start_node[1]['depth'])
                    sp=nx.all_simple_paths(Combo_Graph,start,end)
                    mini = 100
                    count = 0
                    st=[]
                    for t in sp:
                        for u in t:
                            if u[:4]== prefix_2:
                                count=count+1
                        if count < mini:
                            mini = count
                            st=t
                    
                    
                    temp_path=st#nx.shortest_path(comb,start,end)
                    
                
                    for i in range(0,temp_path.__len__()-1):
    
                        if temp_path[i][:4] == prefix_2 and temp_path[i+1][:4] == prefix_1:
                            
                                for y in Combo_Nodes:
                                    if y[0] == temp_path[i]:
                                        temp_node=y
                                for z in Combo_Nodes:
                                    if z[0] == temp_path[i+1]:
                                        temp_node1=z      
                        
                    
                                #temp.append("Pre Transisiton")
                                temp.append(temp_node[1]['Label'])
                                temp.append(temp_node[1]['code'])
                                temp.append(temp_node[1]['CUI']) 
                                temp.append(temp_node[1]['depth'])
                                #temp.append("Post Transisiton")
                                temp.append(temp_node1[1]['Label']) 
                                temp.append(temp_node1[1]['code'])
                                temp.append(temp_node1[1]['CUI'])
                                temp.append(temp_node1[1]['depth'])
                                c=c+1
                                if c%500 == 0 :
                                    print (c,"rows written")

                                writer.writerow(temp)
                                
    
               
f.close()                         
print (op_file , "generated")


