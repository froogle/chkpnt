# Issue tracker: GitHub Issues

Issues and specs for this repo live as GitHub Issues on `froogle/chkpnt`. Use the `gh` CLI for every operation.

## Conventions

- One issue per ticket, never a single combined tickets issue.
- A spec is its own issue labelled `spec`. Its implementation tickets are separate issues that start their body with `Part of #<spec>`.
- Triage state is a label (see `triage-labels.md` for the role strings). An issue carries one triage label at a time.
- Comments and conversation history go in issue comments (`gh issue comment <n>`), not edits to the body.
- The PR that implements a ticket also resolves it: put `Closes #<n>` in the PR body so merging closes the issue.

## When a skill says "publish to the issue tracker"

`gh issue create --title "<title>" --body-file <file> --label <triage-label>`

## When a skill says "fetch the relevant ticket"

`gh issue view <n> --comments`. The user will normally pass the issue number or URL directly.

## Wayfinding operations

Used by `/wayfinder`. The **map** is an issue with one **child** issue per ticket.

- **Map**: an issue labelled `map` whose body holds the Notes / Decisions-so-far / Fog sections.
- **Child ticket**: an issue whose body starts with `Part of #<map>`, then the question. A `type:research`, `type:prototype`, `type:grilling` or `type:task` label records the ticket type.
- **Blocking**: a `Blocked by: #N, #N` line near the top of the body. A ticket is unblocked when every issue it lists is closed.
- **Frontier**: `gh issue list --search "Part of #<map>" --state open` and take the open, unblocked, unassigned issues; lowest number wins.
- **Claim**: assign yourself (`gh issue edit <n> --add-assignee @me`) before any work.
- **Resolve**: comment the answer under an `## Answer` heading, close the issue, then add a context pointer (gist + link) to the map's Decisions-so-far by editing the map issue's body.
