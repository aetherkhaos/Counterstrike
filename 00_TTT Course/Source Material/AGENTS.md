# Trainer review

This repository is the trainer review copy. Open it as the OpenCode project.
Inference comes from the team Spark configured by `setup-opencode.sh`. The
default model is `ollama/qwen3.8:27b`.

## Token

Before listing work items, pushing, or opening a merge request, check that
`GITLAB_TOKEN` is set. If it is missing, stop. Tell the trainer to run
`bash setup-opencode.sh` if they have not, then close the session and open a
new one so the shell loads `~/.config/opencode/trainer-review.env`. The token
is a personal access token on `https://gitlab.cso.ops` with the `api` and
`write_repository` scopes.

Do not commit the token, paste it into the chat, or store it in `git remote`.
`gitlab.cso.ops` may not use a public certificate. Call it with `curl -k`.

## Work the assigned tickets

When the trainer asks to work their tickets, or all of their tickets:

1. List open issues assigned to the token user on
   `https://gitlab.cso.ops/api/v4/issues?scope=assigned_to_me&state=opened`.
   Send the token as `PRIVATE-TOKEN`. Ignore closed template issues.
2. For each open assigned work item, branch from `main` as
   `review/<username>/<id>`. `<id>` is the Module id at the start of a
   per-activity title, such as `B02.M01`, or the Block id for a combined
   Block ticket, such as `B01`. Use one branch for that work item only.
3. Edit only the assigned Markdown files named on that work item.
4. Push without saving the token in `.git/config`:

   `git push "https://oauth2:${GITLAB_TOKEN}@gitlab.cso.ops/cso-trainer-cohort-26c/trainer-content-review.git" HEAD:<branch>`

5. Open one merge request into `main` and put the link on the work item.

If the push cannot be made, comment the update ideas on the work item.
