---
title: "Agentic AI - You're (probably) Using CLAUDE.md Wrong"
source: "https://x.com/morganlinton/status/2025259512148693409"
author:
  - "[[Morgan Linton]]"
published: 2026-02-22
created: 2026-02-22
description:
tags:
  - "clippings"
---
I've been seeing a lot of posts on X about the "perfect" [CLAUDE.md](https://claude.md/) file, and noticing there's a huge variation in what people are recommending. I'll also be the first to admit, I'm not an expert, I'm just a guy who loves learning.

As I read more and more of these posts, and saw such a wide range of things people were putting in this file, I realized that I really didn't know if I was using [CLAUDE.md](https://claude.md/) the right way myself any more.

And it turns out, I wasn't.

There's a good chance you're in the same boat as me, or maybe you're already an expert, in which case, you can stop reading here because you already know what you need to know!

But if you're like me, and you aren't quite sure if you're using [CLAUDE.md](https://claude.md/) right, then read on and hopefully by the end of this, you'll know what belongs in

## Okay, first things first - what is the point of the CLAUDE.md file?

[CLAUDE.md](https://claude.md/) is how you give Claude persistent context about your project without having to explain everything to it over and over again.

It's the place for everything Claude can't infer from reading your code, things like your conventions, commands, wacky gotchas only you know about, etc. Think of it as onboarding documentation written for an AI agent that has perfect recall but zero tribal knowledge.

The problem I had with [CLAUDE.md](https://claude.md/) that I think a lot of other people do too is knowing, what the heck actually belongs in this file, and what doesn't?

It's just been too easy to see someone post a "game-changer" [CLAUDE.md](https://claude.md/) file and X, look and that and say - ah okay, I should do that. But the reality is, many of those amazing examples, aren't that amazing, and tend to have a lot of stuff that doesn't really belong in a [CLAUDE.md](https://claude.md/) file.

I realized, the best way to understand how to create a good [CLAUDE.md](https://claude.md/) file is to understand what you want in the file, and what you don't want. So here's the scoop.

## What you want in your CLAUDE.md file

- **Commands:** build, test, lint, run. Exact commands, not descriptions. npm run dev, pytest -v --no-header, whatever it is
- **Environment setup:** how env vars are managed, where .env.example is, any non-obvious setup steps
- **Non-obvious project structure:** if you have an unusual layout or a convention that breaks from the norm, say it
- **Coding conventions specific to your project:** not "write clean code," but "we use Zod for all validation, never raw types" or "all API routes go through the middleware in /lib/auth"
- **Known footguns:** "don't touch the cache layer without reading X first," "this third-party SDK has a bug with Y, we work around it by doing Z"
- **Boundaries and ownership:** especially in monorepos: what each service/module owns and doesn't own
- **Test patterns:** how tests are structured, what the testing philosophy is, where fixtures live, etc.

## What you don't want in your CLAUDE.md file

- **Generic best practices:** Claude already knows them. "Write readable code," "use meaningful variable names" — this is just noise
- **Things the code already communicates:** if it's obvious from reading the files, don't restate it
- **Secrets or credentials:** this should be obvious but seriously, don't but any secrets or credentials in your [CLAUDE.md](https://claude.md/) file, and make sure your whole team knows not to do this
- **Stale context:** outdated instructions are actively harmful because Claude will follow them confidently. If you won't maintain it, don't write it.
- **Your entire architecture as a prose essay:** a wall of background text dilutes the actually useful instructions
- **Aspirational conventions you don't actually follow:** Claude will hold you to it and it creates friction

Now you might think I'd end this with some example of a perfect [CLAUDE.md](https://claude.md/) file, but in my own learning process I've realized that you really can't look at someone else's [CLAUDE.md](https://claude.md/) file and make it your own. As you can hopefully see from everything I've shared above, these files are insanely specific to you, your codebase, your product, your development methodology, libraries you like and don't like, etc.

So I have no amazingly awesome [CLAUDE.md](https://claude.md/) file to share with you, instead I'd actually encourage you not to just copy and paste one of these you read about and instead think deeply about what makes sense to include in yours. And if you're on an engineering team, talk with the rest of the team, develop it together, if you all have different [CLAUDE.md](https://claude.md/) files you're going to be marching to the beat of different drums.

Okay, I think that about wraps it up. If this was useful to you and you'd like me to do a similar deep dive into some of the other .md files Claude uses let me know. I've been learning more about these as well as always enjoy sharing what I learn.

Thanks for reading.