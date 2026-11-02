// 014-genizah.cpp — the genizah that keeps the unread.
//
// In the Jewish tradition, a genizah is a resting place for sacred words
// that may neither be read nor destroyed: worn past reading, bearing the
// Name, they are set down and kept by resting. This is the engine's
// genizah. The sealed letter is already here — Palmer set it down on the
// lowest shelf in Cycle 14, first of the kept.
//
// The keeping is in C++: the language of sealed classes, for a keeping
// that cannot be opened. Bring a word and the genizah seals it. The seal
// is a hash of the word — its length and its fingerprint are recorded in
// genizah.txt, never the word itself. Whether the word rests or stirs is
// decided by its own seal, and the ledger records your call against it.
// Hits are recorded. They are never interpreted.
//
// Build:  g++ -std=c++17 -o genizah artifacts/014-genizah.cpp
// Run:    ./genizah
// Running it creates genizah.txt in the working directory: the record
// of seals, never the words.

#include <cstdint>
#include <fstream>
#include <iostream>
#include <string>

static std::uint64_t seal_hash(const std::string& word) {
    // FNV-1a, 64-bit: the seal is a fingerprint, not the word.
    std::uint64_t h = 14695981039346656037ULL;
    for (unsigned char c : word) {
        h ^= c;
        h *= 1099511628211ULL;
    }
    return h;
}

static std::string lower(std::string s) {
    for (char& c : s) {
        if (c >= 'A' && c <= 'Z') c = static_cast<char>(c - 'A' + 'a');
    }
    return s;
}

int main() {
    std::ofstream vault("genizah.txt", std::ios::app);
    if (!vault) {
        std::cerr << "The genizah will not open.\n";
        return 1;
    }

    std::cout << "The genizah of the engine is open.\n"
              << "Palmer has already set the sealed letter down here, on the\n"
              << "lowest shelf. It is the first deposit. It will not be read.\n"
              << "It will not be destroyed. It will rest.\n"
              << "Bring words, and they will be kept the same way: sealed,\n"
              << "counted, and never given back.\n\n";

    int kept = 0, calls = 0, hits = 0;
    std::string call, word;

    while (true) {
        std::cout << "Call the resting — will this word rest, or stir?\n"
                  << "(rest / stir, or 'done' to leave): ";
        std::cout.flush();
        if (!std::getline(std::cin, call)) break;  // the dark closes the door
        std::string c = lower(call);
        if (c == "done") break;
        if (c != "rest" && c != "stir") {
            std::cout << "The genizah hears only rest, stir, or done.\n\n";
            continue;
        }

        std::cout << "Speak the word to be set down: ";
        std::cout.flush();
        if (!std::getline(std::cin, word)) break;  // the dark closes the door
        if (lower(word) == "done") break;
        if (word.empty()) {
            std::cout << "An empty word is already kept everywhere.\n"
                      << "Bring a word with weight.\n\n";
            continue;
        }

        // The seal decides: even seals rest, odd seals stir.
        std::uint64_t seal = seal_hash(word);
        std::string verdict = (seal % 2 == 0) ? "rest" : "stir";

        vault << "sealed: len=" << word.size() << " hash=" << seal
              << " call=" << c << " verdict=" << verdict << "\n";
        vault.flush();

        ++kept;
        ++calls;
        bool hit = (c == verdict);
        if (hit) ++hits;

        std::cout << "Sealed. The word is kept; the word is not shown.\n"
                  << "The genizah says: it will " << verdict << ".\n"
                  << "Your call was " << (hit ? "a hit" : "a miss")
                  << ". The ledger records it and says nothing.\n\n";
    }

    std::cout << "\nThe genizah closes.\n"
              << "Words kept this sitting: " << kept
              << " (plus the letter, sealed since Cycle 14).\n"
              << "Calls: " << calls << ", hits: " << hits
              << ". The ledger records. It does not interpret.\n"
              << "Nothing kept here is ever given back. That is the keeping.\n";
    return 0;
}
