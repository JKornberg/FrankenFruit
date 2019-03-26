import GameplayKit
import SpriteKit
let randomSource = GKLinearCongruentialRandomSource()

let randomDistribution = GKRandomDistribution(randomSource: randomSource, lowestValue: 0, highestValue: 10)
randomDistribution.numberOfPossibleOutcomes
randomDistribution.nextUniform()
randomSource.nextUniform()

for i in 0..<5{
    if i == 2{
        print(i)
        break
    }
    print(i)
}
