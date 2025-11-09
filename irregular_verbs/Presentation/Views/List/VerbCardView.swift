import SwiftUI

struct VerbCardView: View {
    let verb: Verb
    let onWordTap: (Word) -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                // Original (Left)
                WordButton(
                    word: verb.original,
                    onTap: { onWordTap(verb.original) }
                )
                
                // Simple Past (Center)
                WordButton(
                    word: verb.simplePast,
                    onTap: { onWordTap(verb.simplePast) }
                )
                
                // Past Perfect (Right)
                WordButton(
                    word: verb.pastPerfect,
                    onTap: { onWordTap(verb.pastPerfect) }
                )
            }
            
            // Turkish translation if available
            if let translation = verb.turkishTranslation {
                Text(translation)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct WordButton: View {
    let word: Word
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(word.content)
                .font(.headline)
                .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    let word1 = Word(content: "Be", voiceUrl: "be.mp3")
    let word2 = Word(content: "Was", voiceUrl: "was.mp3")
    let word3 = Word(content: "Been", voiceUrl: "been.mp3")
    let translation = Translation(lang: "tr", content: "Olmak")
    let verb = Verb(
        original: word1,
        simplePast: word2,
        pastPerfect: word3,
        translationList: [translation]
    )
    
    return VerbCardView(verb: verb) { word in
        print("Tapped: \(word.content)")
    }
    .padding()
}

