using ..Point
const factorsocialforce = 4.5
const factorobstacleforce = 1.0
const factordesiredforce = 1.0
const factorlookaheadforce = 1.0
const timeStep = 0.01
#const timeStep = 0.1
const obstacleForceSigma = 0.8

const agentRadius = 0.2

#const relaxationTime = 0.5
const zeroVector = Point(0.0, 0.0)

const baseFolderWindows = "C:/Users/altieres/Box Sync/Copy/Mestrado/Dissertacao/materialJuliaLang"
const baseFolderLinux = "/home/altieres/Dropbox/Mestrado/FSFM/src/"
const baseFolder = @linux? baseFolderLinux:baseFolderWindows

const baseFolderScenario = "/home/altieres/Dropbox/Mestrado/scenarios"
const baseFolderSimulation = "/home/altieres/"
