import Foundation
import WidgetKit

struct WatchComplicationProvider: TimelineProvider {
  func placeholder(in context: Context) -> WatchComplicationEntry {
    WatchComplicationEntry(
      date: Date(),
      bookTitle: "Book Title",
      progress: 0.35,
      chapterProgress: 0.6,
      timeRemaining: 3600
    )
  }

  func getSnapshot(in context: Context, completion: @escaping (WatchComplicationEntry) -> Void) {
    completion(currentEntry())
  }

  func getTimeline(
    in context: Context,
    completion: @escaping (Timeline<WatchComplicationEntry>) -> Void
  ) {
    let entry = currentEntry()

    let policy: TimelineReloadPolicy
    if let chapterEnd = entry.chapterInterval?.upperBound {
      policy = .after(chapterEnd)
    } else if let bookEnd = entry.bookInterval?.upperBound {
      policy = .after(bookEnd)
    } else {
      policy = .never
    }

    completion(Timeline(entries: [entry], policy: policy))
  }

  private func currentEntry() -> WatchComplicationEntry {
    guard let state = WatchComplicationStorage.load() else {
      return .empty
    }

    return entry(for: state)
  }

  private func entry(for state: WatchComplicationState) -> WatchComplicationEntry {
    let staticChapterProgress: Double?
    if let start = state.chapterStart, let end = state.chapterEnd, end > start {
      staticChapterProgress = min(1, max(0, (state.currentTime - start) / (end - start)))
    } else {
      staticChapterProgress = state.chapterProgress
    }

    var bookInterval: ClosedRange<Date>?
    var chapterInterval: ClosedRange<Date>?

    if state.isPlaying, let savedAt = state.savedAt {
      let rate = max(0.1, state.playbackRate ?? 1)

      if state.duration > 0 {
        let start = savedAt.addingTimeInterval(-state.currentTime / rate)
        let end = savedAt.addingTimeInterval((state.duration - state.currentTime) / rate)
        if start < end {
          bookInterval = start...end
        }
      }

      if let chapterStart = state.chapterStart, let chapterEnd = state.chapterEnd, chapterEnd > chapterStart {
        let start = savedAt.addingTimeInterval(-(state.currentTime - chapterStart) / rate)
        let end = savedAt.addingTimeInterval((chapterEnd - state.currentTime) / rate)
        if start < end {
          chapterInterval = start...end
        }
      }
    }

    return WatchComplicationEntry(
      date: Date(),
      bookTitle: state.bookTitle,
      progress: state.duration > 0 ? min(1, state.currentTime / state.duration) : 0,
      chapterProgress: staticChapterProgress,
      timeRemaining: max(0, state.duration - state.currentTime),
      bookInterval: bookInterval,
      chapterInterval: chapterInterval
    )
  }
}
