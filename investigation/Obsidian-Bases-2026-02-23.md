---
title: "Obsidian Bases Investigation Report"
date: 2026-02-23
topic: "Obsidian Bases for Vault Organization"
category: "Productivity Tools"
tags: ["obsidian", "bases", "vault-organization", "pkm", "database", "yaml"]
status: "complete"
source: "Yuzhe Research"
type: "investigation"
---

# Obsidian Bases Investigation Report

**Research Date:** 2026-02-23  
**Investigation Topic:** Obsidian Bases for Vault Organization  
**Focus Areas:** What it is, Use Cases, Applications for Research Workflow

---

## 1. What is Obsidian Bases?

**Obsidian Bases** is a native Obsidian feature (currently in beta/early access) that brings **database-like functionality** to your Obsidian vault. Think of it as a lightweight, YAML-based alternative to Notion databases or Airtable — but fully integrated with your markdown notes.

### Core Concept

A **Base** is a `.base` file that defines **dynamic views** of your notes. Instead of manually tracking notes in spreadsheets or databases, Bases automatically:
- **Collect** notes matching certain criteria (tags, folders, properties)
- **Display** them in customizable views (table, cards, list, map)
- **Calculate** derived values via formulas
- **Filter, sort, and group** your notes dynamically

### Bases vs. Dataview

| Feature | Dataview (Plugin) | Obsidian Bases (Native) |
|---------|-------------------|-------------------------|
| **Syntax** | JavaScript-like queries | YAML-based declarative config |
| **Learning curve** | Steeper (programming) | Gentler (configuration) |
| **Performance** | Can be slow on large vaults | Optimized native performance |
| **Portability** | Requires plugin | Native Obsidian feature |
| **Formulas** | JavaScript expressions | Purpose-built formula language |
| **Extensibility** | Very flexible | Growing feature set |

**Bottom line:** Bases is Obsidian's "official" answer to database views — simpler than Dataview for most use cases, with better performance.

---

## 2. How Bases Works

### File Structure

A `.base` file is YAML that defines:

```yaml
# 1. GLOBAL FILTERS - which notes to include
filters:
  and:
    - file.hasTag("project")
    - 'status != "archived"'

# 2. FORMULAS - computed properties
formulas:
  days_until_due: 'if(due, (date(due) - today()).days, "")'
  is_overdue: 'if(due, date(due) < today() && status != "done", false)'

# 3. PROPERTIES - display settings
properties:
  status:
    displayName: "Status"
  formula.days_until_due:
    displayName: "Days Left"

# 4. VIEWS - how to display the data
views:
  - type: table
    name: "Active Projects"
    order:
      - file.name
      - status
      - formula.days_until_due
    groupBy:
      property: status
    summaries:
      formula.days_until_due: Average
```

### View Types

| View | Best For | Example Use |
|------|----------|-------------|
| **Table** | Structured data, comparisons | Task lists, project tracking |
| **Cards** | Visual browsing, media | Reading list, image galleries |
| **List** | Quick scanning, simple lists | Daily notes, quick links |
| **Map** | Location-based data | Travel notes, site visits |

---

## 3. Practical Use Cases for Research Workflows

### Use Case 1: Literature Review & Paper Management

**Problem:** Track dozens of papers with reading status, priority, and notes.

**Base Configuration:**
```yaml
filters:
  or:
    - file.hasTag("paper")
    - file.hasTag("article")

formulas:
  reading_time: 'if(pages, (pages * 2).toString() + " min", "")'
  status_icon: 'if(status == "reading", "📖", if(status == "done", "✅", "📚"))'
  year_published: 'if(published_date, date(published_date).year, "")'

properties:
  author:
    displayName: "Author"
  journal:
    displayName: "Journal"
  formula.status_icon:
    displayName: ""

views:
  - type: cards
    name: "Reading Queue"
    filters:
      and:
        - 'status == "to-read"'
    order:
      - cover_image
      - file.name
      - author
      - formula.status_icon

  - type: table
    name: "Papers by Year"
    groupBy:
      property: formula.year_published
      direction: DESC
    order:
      - file.name
      - author
      - journal
      - status
```

**Benefits:**
- Visual card view of papers to read
- Quick filtering by status, year, author
- Estimated reading time calculation
- One-click access to full notes

---

### Use Case 2: Research Project Tracking

**Problem:** Manage multiple research projects with deadlines, collaborators, and deliverables.

**Base Configuration:**
```yaml
filters:
  and:
    - file.inFolder("Projects")
    - file.hasTag("research")

formulas:
  days_until_deadline: 'if(deadline, (date(deadline) - today()).days, "")'
  is_overdue: 'if(deadline, date(deadline) < today() && status != "completed", false)'
  progress_pct: 'if(total_tasks && completed_tasks, (completed_tasks / total_tasks * 100).round(0) + "%", "0%")'
  last_activity: 'file.mtime.relative()'

properties:
  pi:
    displayName: "PI"
  collaborators:
    displayName: "Team"
  formula.progress_pct:
    displayName: "Progress"

views:
  - type: table
    name: "Active Projects"
    filters:
      and:
        - 'status != "completed"'
        - 'status != "cancelled"'
    order:
      - file.name
      - pi
      - status
      - formula.progress_pct
      - formula.days_until_deadline
    groupBy:
      property: status
    summaries:
      formula.progress_pct: Average

  - type: cards
    name: "Project Overview"
    order:
      - file.name
      - description
      - pi
      - formula.progress_pct
```

**Benefits:**
- Dashboard of all active research
- Visual progress tracking
- Overdue deadline warnings
- Collaboration status at a glance

---

### Use Case 3: MUST Telescope Project Management

**Problem:** Track components, milestones, and responsibilities for the MUST telescope project.

**Base Configuration:**
```yaml
filters:
  and:
    - file.inFolder("MUST")
    - file.hasTag("component")

formulas:
  days_in_review: 'if(review_date, (today() - date(review_date)).days, "")'
  completion_icon: 'if(completion >= 90, "✅", if(completion >= 50, "🟡", "🔴"))'
  next_milestone_days: 'if(next_milestone, (date(next_milestone) - today()).days, "")'

properties:
  subsystem:
    displayName: "Subsystem"
    # e.g., "Focal Plane", "Spectrograph", "Mount"
  responsible:
    displayName: "Responsible"
  vendor:
    displayName: "Vendor"
  formula.completion_icon:
    displayName: "Status"

summaries:
  avg_completion: 'values.filter(value.isType("number")).mean().round(1)'

views:
  - type: table
    name: "Components by Subsystem"
    order:
      - file.name
      - subsystem
      - responsible
      - vendor
      - completion
      - formula.completion_icon
      - next_milestone
    groupBy:
      property: subsystem
    summaries:
      completion: avg_completion

  - type: table
    name: "Upcoming Milestones"
    filters:
      and:
        - 'next_milestone != ""'
        - 'completion < 100'
    order:
      - next_milestone
      - file.name
      - responsible
      - formula.next_milestone_days
```

**Benefits:**
- Component tracking by subsystem
- Vendor management
- Milestone countdown
- Completion progress visualization

---

### Use Case 4: Daily Research Journal Index

**Problem:** Navigate and review daily research notes over time.

**Base Configuration:**
```yaml
filters:
  and:
    - file.inFolder("journal/2026")
    - '/^\d{4}-\d{2}-\d{2}$/.matches(file.basename)'

formulas:
  word_estimate: '(file.size / 5).round(0)'
  day_of_week: 'date(file.basename).format("dddd")'
  days_ago: '(today() - date(file.basename)).days'
  has_tasks: 'file.hasTag("task") || file.hasTag("todo")'

properties:
  mood:
    displayName: "Mood"
  focus_area:
    displayName: "Focus"
  formula.word_estimate:
    displayName: "~Words"
  formula.day_of_week:
    displayName: "Day"

views:
  - type: table
    name: "Recent Entries"
    limit: 30
    order:
      - file.name
      - formula.day_of_week
      - focus_area
      - formula.word_estimate
      - file.mtime

  - type: list
    name: "Task Days"
    filters:
      and:
        - 'formula.has_tasks == true'
    order:
      - file.name
      - focus_area
```

**Benefits:**
- Quick review of recent work
- Identify patterns in productivity
- Find notes by focus area
- Word count tracking

---

### Use Case 5: arXiv Paper Digest Management

**Problem:** Organize and track papers from daily arXiv digests.

**Base Configuration:**
```yaml
filters:
  and:
    - file.hasTag("arxiv")
    - file.hasTag("paper")

formulas:
  days_since_added: '(today() - file.ctime).days'
  relevance_score: 'if(relevance, relevance, 0)'
  is_recent: 'file.ctime > now() - "7d"'
  priority_label: 'if(priority == "high", "🔴", if(priority == "medium", "🟡", "🟢"))'

properties:
  arxiv_id:
    displayName: "arXiv ID"
  authors:
    displayName: "Authors"
  category:
    displayName: "Category"
  formula.priority_label:
    displayName: "Priority"

views:
  - type: table
    name: "This Week's Papers"
    filters:
      and:
        - 'formula.is_recent == true'
    order:
      - file.name
      - authors
      - category
      - formula.priority_label
      - relevance

  - type: cards
    name: "High Priority Papers"
    filters:
      and:
        - 'priority == "high"'
        - 'status != "read"'
    order:
      - file.name
      - authors
      - abstract
      - formula.priority_label

  - type: table
    name: "By Category"
    groupBy:
      property: category
    order:
      - file.name
      - authors
      - status
      - formula.days_since_added
```

**Benefits:**
- Prioritize incoming papers
- Track reading status
- Organize by research category
- Identify stale papers (old, unread)

---

### Use Case 6: Meeting Notes & Action Items

**Problem:** Track meetings, action items, and follow-ups.

**Base Configuration:**
```yaml
filters:
  and:
    - file.hasTag("meeting")

formulas:
  days_since_meeting: '(today() - date(meeting_date)).days'
  open_actions: 'if(actions, actions.filter(a => !a.done).length, 0)'
  has_open_actions: 'formula.open_actions > 0'

properties:
  meeting_date:
    displayName: "Date"
  attendees:
    displayName: "Attendees"
  project:
    displayName: "Project"
  formula.open_actions:
    displayName: "Open Actions"

views:
  - type: table
    name: "Recent Meetings"
    limit: 20
    order:
      - meeting_date
      - file.name
      - project
      - attendees
      - formula.open_actions

  - type: table
    name: "Action Items Pending"
    filters:
      and:
        - 'formula.has_open_actions == true'
    order:
      - meeting_date
      - file.name
      - project
      - formula.open_actions
```

**Benefits:**
- Never lose track of action items
- Quick access to recent meeting notes
- Project-based meeting organization
- Follow-up reminders

---

## 4. Key Formula Patterns for Researchers

### Date Calculations
```yaml
formulas:
  # Days until deadline
  days_until: 'if(deadline, (date(deadline) - today()).days, "")'
  
  # Days since created
  days_old: '(now() - file.ctime).days'
  
  # Days since modified
  days_since_edit: '(now() - file.mtime).days'
  
  # Format date nicely
  formatted_date: 'date(meeting_date).format("MMM DD, YYYY")'
```

### Status Indicators
```yaml
formulas:
  # Traffic light status
  status_icon: 'if(progress >= 90, "✅", if(progress >= 50, "🟡", "🔴"))'
  
  # Overdue warning
  is_overdue: 'if(due_date, date(due_date) < today() && status != "done", false)'
  
  # Urgency level
  urgency: 'if(formula.days_until < 3, "🔴 High", if(formula.days_until < 7, "🟡 Medium", "🟢 Low"))'
```

### Progress Tracking
```yaml
formulas:
  # Completion percentage
  pct_complete: 'if(total && completed, (completed / total * 100).round(0) + "%", "0%")'
  
  # Word count estimate
  word_count: '(file.size / 5).round(0)'
  
  # Page estimate (250 words/page)
  page_estimate: '(file.size / 5 / 250).round(1)'
```

### Text Processing
```yaml
formulas:
  # Reading time estimate
  reading_time: 'if(word_count, (word_count / 200 * 60).round(0).toString() + " min", "")'
  
  # First author extraction (if authors is "First; Second; Third")
  first_author: 'if(authors, authors.split(";").get(0).trim(), "")'
  
  # Short title (first 50 chars)
  short_title: 'if(file.name.length > 50, file.name.slice(0, 50) + "...", file.name)'
```

---

## 5. Getting Started with Bases

### Step 1: Create Your First Base

1. **Create a `.base` file** in your vault:
   ```
   New Note → Name it "Papers.base"
   ```

2. **Add basic configuration:**
   ```yaml
   filters:
     and:
       - file.hasTag("paper")
   
   views:
     - type: table
       name: "All Papers"
       order:
         - file.name
         - file.mtime
   ```

3. **View the Base:**
   - Open the `.base` file
   - Obsidian renders it as a dynamic table

### Step 2: Add Frontmatter to Notes

For Bases to work, your notes need **properties** (YAML frontmatter):

```yaml
---
title: "Dark Matter Halos in Galaxy Clusters"
authors: "Smith, J.; Jones, M."
journal: "ApJ"
published_date: 2025-03-15
status: "to-read"
priority: "high"
pages: 24
category: "cosmology"
---
```

### Step 3: Iterate and Expand

- Start with one Base
- Add more views as needed
- Create formulas for calculated fields
- Use the skill to automate Base creation

---

## 6. Using the Obsidian Bases Skill

The **obsidian-bases skill** (already installed on your Mac Studio) enables AI agents to:

- **Create** valid `.base` files
- **Edit** existing Bases
- **Generate** formulas and filters
- **Validate** Base syntax

### Example Skill Usage

```
You: Create a Base to track my MUST telescope components

Agent: Creates "MUST Components.base" with:
- Filters for telescope component notes
- Formulas for completion tracking
- Views by subsystem and status
```

### What the Skill Can Do

| Capability | Example |
|------------|---------|
| Create Bases | "Create a reading list Base" |
| Edit Bases | "Add a view for overdue tasks" |
| Write formulas | "Calculate days until deadline" |
| Debug Bases | "Fix this filter that's not working" |
| Generate configs | "Create a Base for project tracking" |

---

## 7. Best Practices

### Do:
- ✓ Start simple, add complexity gradually
- ✓ Use consistent property names across notes
- ✓ Leverage file properties (file.mtime, file.tags)
- ✓ Create multiple views for different use cases
- ✓ Use formulas to reduce manual data entry
- ✓ Group by status, project, or category

### Don't:
- ✗ Create overly complex filters initially
- ✗ Duplicate data that's already in file properties
- ✗ Forget to add frontmatter to notes
- ✗ Make formulas too complex (hard to debug)
- ✗ Use Bases for everything (some things are better as simple lists)

---

## 8. Summary

**Obsidian Bases** brings database-like views to your markdown vault without leaving Obsidian. For your research workflow, it can:

1. **Organize literature** - Track papers, reading status, priorities
2. **Manage projects** - MUST telescope components, milestones, deliverables
3. **Index daily work** - Navigate journals, track productivity patterns
4. **Prioritize inputs** - arXiv digests, meeting action items
5. **Visualize progress** - Completion percentages, deadline countdowns

**Key advantages:**
- Native Obsidian feature (no plugin needed)
- YAML-based (human-readable, portable)
- Formula language designed for note-taking
- Multiple view types (table, cards, list, map)
- AI skill available for automated creation

**Next steps:**
1. Create your first Base (start with Papers or Projects)
2. Add frontmatter to a few existing notes
3. Experiment with views and formulas
4. Use the skill to generate more complex Bases

---

*Report compiled by Yuzhe | Research Assistant*  
*Date: 2026-02-23*  
*File: `~/Desktop/yuzhe/investigation/Obsidian-Bases-2026-02-23.md`*
