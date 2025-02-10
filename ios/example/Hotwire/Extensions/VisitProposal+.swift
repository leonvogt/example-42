import HotwireNative

extension VisitProposal {
    var popUntilHandling: Bool {
        (properties["custom_presentation"] as? String) == "pop_until"
    }
}
