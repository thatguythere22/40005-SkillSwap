import Foundation

/// Adds a small demonstration community on first launch so every core workflow can be evaluated locally.
struct DemoDataSeeder {
    let repository: SkillSwapRepository

    func seedIfNeeded(currentMemberID: String) {
        do {
            let community = try repository.fetchOpenRequests(excludingOwnerID: currentMemberID, category: nil)
            if community.isEmpty {
                let samples = [
                    SkillRequest(
                        ownerID: "community-maya",
                        ownerName: "Maya",
                        needTitle: "Help fixing a bike chain",
                        needDescription: "My chain keeps slipping off when I change gears. I need someone who can show me how to adjust it properly.",
                        offeredSkill: "Can help with Canva and posters",
                        category: .practical,
                        availability: "Weekdays after 4 pm"
                    ),
                    SkillRequest(
                        ownerID: "community-omar",
                        ownerName: "Omar",
                        needTitle: "Conversational Italian practice",
                        needDescription: "I know the basics but want 30 minutes of casual conversation before travelling later this year.",
                        offeredSkill: "Can teach beginner guitar",
                        category: .language,
                        availability: "Tuesday or Thursday evenings"
                    ),
                    SkillRequest(
                        ownerID: "community-jess",
                        ownerName: "Jess",
                        needTitle: "Excel formulas for an assignment",
                        needDescription: "I understand spreadsheets but keep getting stuck on nested IF and lookup formulas.",
                        offeredSkill: "Can proofread essays",
                        category: .study,
                        availability: "Most afternoons on campus"
                    ),
                    SkillRequest(
                        ownerID: "community-noah",
                        ownerName: "Noah",
                        needTitle: "Portrait photography basics",
                        needDescription: "I want to understand lighting and camera settings for better portraits, not professional editing.",
                        offeredSkill: "Can help with Python basics",
                        category: .creative,
                        availability: "Saturday mornings"
                    )
                ]

                for request in samples {
                    try repository.saveRequest(request)
                }
            }

            let ownRequests = try repository.fetchRequests(ownerID: currentMemberID)
            if ownRequests.isEmpty {
                let sampleOwnRequest = SkillRequest(
                    ownerID: currentMemberID,
                    ownerName: "You",
                    needTitle: "Help editing a short video",
                    needDescription: "I need help tightening a two-minute class video and making the audio levels more consistent.",
                    offeredSkill: "Can help with maths tutoring",
                    category: .creative,
                    availability: "Wednesday afternoon"
                )
                try repository.saveRequest(sampleOwnRequest)

                let incomingOffer = SkillOffer(
                    requestID: sampleOwnRequest.id,
                    requestOwnerID: currentMemberID,
                    offeredByID: "community-lena",
                    offeredByName: "Lena",
                    skillProvided: "Video editing",
                    message: "I use Premiere regularly and can help clean up the edit. I would appreciate some help with first-year calculus in return."
                )
                try repository.saveOffer(incomingOffer)
            }
        } catch {
            // Demonstration records are non-critical. The main app still works with an empty store.
        }
    }
}
