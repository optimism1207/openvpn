#!/usr/bin/env python3

import os,sys,re

def decorate():
    for i in range(0,100):
        print("=",end="")
        if i == 99:
            print("=")

f = open("/etc/openvpn/openvpn-status.log", "r")
data = f.readlines()
data2= []
for string in data:
    string = string.rstrip("\n")
    data2.append(string)

decorate()
for title in data2[:2]:
    if ',' in title:
        title = title.replace("," ," ")    
    print(title)

decorate()
x = data2.index("ROUTING TABLE")
for s1 in data2[2:x]:
    s1 = s1.split(",")
    print("%-15s %-23s %-20s %-15s %-20s" % (s1[0] ,s1[1] ,s1[2] ,s1[3] ,s1[4]))

decorate()
print(data2[x])
decorate()

x2 = data2.index("GLOBAL STATS")
for s2 in data2[x+1:x2]:
    #s2 = s2.split(",")
    s2 = s2.replace("," ,"#")
    regex = re.compile(r"\/\d\d")
    result = regex.search(s2)
    if result != None:
        continue    
    s2 = s2.split("#")
    print("%-18s %-13s %-23s %-15s" % (s2[0] ,s2[1] ,s2[2] ,s2[3]))
decorate()

f.close()


