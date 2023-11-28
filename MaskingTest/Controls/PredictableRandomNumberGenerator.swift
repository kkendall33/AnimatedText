
import GameplayKit

public class PredictableRandomNumberGenerator {

    var minValue: Double
    var maxValue: Double
    var primarySeed: UInt64

    public init(minValue: Double, maxValue: Double, primarySeed: UInt64) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.primarySeed = primarySeed
    }

    public func randomNumber(timeInterval: Double) -> Double {
        // Use the provided seed along with the class-level seed to generate a random number
        var hasher = Hasher()
        hasher.combine(timeInterval)
        hasher.combine(self.primarySeed)
        let combinedSeed = UInt64(bitPattern: Int64(hasher.finalize()))

        // Set up the random number generator
        let randomSource = GKMersenneTwisterRandomSource(seed: combinedSeed)

        // Generate a random number within the specified range
        let randomFraction = randomSource.nextUniform()
        let rangeWidth = maxValue - minValue
        let scaledRandomValue = Double(randomFraction) * rangeWidth
        let finalRandomValue = scaledRandomValue + minValue

        return finalRandomValue
    }
}
