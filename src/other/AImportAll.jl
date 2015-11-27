import FSFM.Load.loadAllXML
import FSFM.doEvacuation
import FSFM.Load.saveSimulation

print("start simulation\n")
print("\t start loading scene and crowd \n")
file = "evacuation3"
(scene,crowd) = loadAllXML(file)
print("\t loaded scene and crowd \n")
print("\t running simulation \n")
log = doEvacuation(scene,crowd,1000)
print("\t simulation ended \n")
print("\t saving simulation  \n")
saveSimulation("desiredFuzzy",scene,crowd,log)
print("\t simulation ended \n")
#saveAll(log)
