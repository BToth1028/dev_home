# Implementation Checklist

**Created**: October 27, 2025
**Purpose**: Step-by-step checklist for implementing the complete system
**Estimated Time**: 16-24 hours over 2-3 weeks

---

## Phase 1: VECTOR_MGMT Auto-Injection (Week 1)

**Goal:** $480/week token savings
**Time:** 4-8 hours
**ROI:** 1 week payback

### Day 1: Validation (2 hours)

- [ ] **Start VECTOR_MGMT service**
  ```powershell
  cd C:\AI_Coding\00_SYSTEM\01_INFRASTRUCTURE\00_VECTOR_MGMT\40_RUNTIME
  .\START_VEC_MGMT.ps1
  ```

- [ ] **Wait for startup** (~30 seconds)

- [ ] **Test health endpoint**
  ```powershell
  curl http://localhost:8765/health
  # Expected: {"ok": true, "db_rows": 12412}
  ```

- [ ] **Test search endpoint**
  ```powershell
  curl "http://localhost:8765/search?q=recent+work&k=5"
  # Expected: JSON array with 5 conversations
  ```

- [ ] **Manual context test**
  ```powershell
  $context = Invoke-RestMethod "http://localhost:8765/search?q=authentication&k=5"
  $context | ConvertTo-Json | Set-Clipboard
  # Paste into Cursor chat, verify it's helpful
  ```

- [ ] **Measure baseline token usage**
  - Note current tokens/chat in Cursor
  - Document typical context messages
  - Save baseline for comparison

### Day 2: Auto-Injection Setup (2 hours)

- [ ] **Copy automation scripts**
  ```powershell
  cp -Recurse C:\AI_Coding\00_SYSTEM\01_INFRASTRUCTURE\01_CTXT_MGMT\TIER-02 `
      C:\DEV\infra\context-automation\
  ```

- [ ] **Test process monitor**
  ```powershell
  cd C:\DEV\infra\context-automation
  .\t2_proc_monitor.ps1
  # Should detect Cursor if running
  ```

- [ ] **Test AutoHotkey script**
  ```powershell
  .\t2_chat_time.ahk
  # Should show icon in system tray
  ```

- [ ] **Test query script**
  ```powershell
  .\query_vect_api.ps1 -Query "test" -Count 5 -Verbose
  # Should return formatted markdown context
  ```

- [ ] **Verify all components working independently**

### Day 3: End-to-End Test (2 hours)

- [ ] **Start all components**
  ```powershell
  cd C:\DEV\infra\context-automation
  Start-Process pwsh -ArgumentList "-File .\t2_proc_monitor.ps1"
  Start-Process ".\t2_chat_time.ahk"
  ```

- [ ] **Open Cursor**

- [ ] **Press Ctrl+N** (new chat)

- [ ] **Expected behavior checklist:**
  - [ ] Input field locks briefly
  - [ ] "Retrieving context..." message appears
  - [ ] Context injects within 2-3 seconds
  - [ ] Input field unlocks
  - [ ] Context is well-formatted
  - [ ] Context is relevant

- [ ] **Test multiple times** (at least 3 new chats)

- [ ] **Verify context quality**
  - [ ] Recent work appears
  - [ ] Relevance scores >0.5
  - [ ] Formatting is clean
  - [ ] No errors or crashes

### Day 4: Optimization & Automation (2 hours)

- [ ] **Tune query script**
  - [ ] Edit `query_vect_api.ps1`
  - [ ] Test different query strings
  - [ ] Test different result counts (5, 10, 15)
  - [ ] Pick optimal settings

- [ ] **Set up automatic startup**
  ```powershell
  $startup = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"

  # Create startup script
  $script = @"
  cd C:\DEV\infra\context-automation
  Start-Process pwsh -ArgumentList "-File .\t2_proc_monitor.ps1" -WindowStyle Hidden
  Start-Process ".\t2_chat_time.ahk"
  "@ | Out-File "$startup\start-vector-mgmt.ps1"
  ```

- [ ] **Test startup** (restart computer, verify services start)

- [ ] **Measure token savings**
  - [ ] Use Cursor for 1 week with auto-injection
  - [ ] Track tokens per chat
  - [ ] Compare to baseline
  - [ ] **Target:** 50%+ reduction

- [ ] **Document any issues encountered**

### Success Criteria

- [ ] API responds in <100ms
- [ ] Search results are relevant (subjective assessment)
- [ ] Auto-injection works reliably on Ctrl+N
- [ ] Context appears within 3 seconds
- [ ] Token usage reduced by 50%+ vs baseline
- [ ] No crashes or errors during normal use

---

## Phase 2: Hot Context Builder (Week 2)

**Goal:** Additional 10-15% token savings
**Time:** 8 hours

### Day 1: Docker Services Setup (3 hours)

- [ ] **Create directory structure**
  ```powershell
  mkdir C:\DEV\infra\vector-services
  mkdir C:\DEV\infra\vector-services\data
  mkdir C:\DEV\infra\vector-services\data\qdrant
  mkdir C:\DEV\infra\vector-services\data\ollama
  ```

- [ ] **Start Qdrant**
  ```powershell
  docker run -d -p 6333:6333 `
      -v C:\DEV\infra\vector-services\data\qdrant:/qdrant/storage `
      --name qdrant `
      --restart unless-stopped `
      qdrant/qdrant:latest
  ```

- [ ] **Wait 30 seconds for Qdrant startup**

- [ ] **Verify Qdrant**
  ```powershell
  curl http://localhost:6333
  # Expected: JSON response with version info
  ```

- [ ] **Start Ollama**
  ```powershell
  docker run -d -p 11434:11434 `
      -v C:\DEV\infra\vector-services\data\ollama:/root/.ollama `
      --name ollama `
      --restart unless-stopped `
      ollama/ollama:latest
  ```

- [ ] **Wait 30 seconds for Ollama startup**

- [ ] **Verify Ollama**
  ```powershell
  curl http://localhost:11434
  # Expected: "Ollama is running"
  ```

- [ ] **Pull embedding model**
  ```powershell
  docker exec ollama ollama pull nomic-embed-text
  # Wait for download (can take 5-10 min)
  ```

- [ ] **Verify model installed**
  ```powershell
  docker exec ollama ollama list
  # Should show nomic-embed-text
  ```

### Day 2: Initial Build (3 hours)

- [ ] **Install Python dependencies**
  ```powershell
  cd C:\DEV\tools\context-builder
  pip install -r requirements.txt
  ```

- [ ] **Review settings.yaml**
  - [ ] Check sources paths are correct
  - [ ] Review queries (customize if needed)
  - [ ] Verify top_k and relevance_threshold

- [ ] **Run health check**
  ```powershell
  python build_context.py health
  # Expected: All services OK
  ```

- [ ] **Run initial indexing**
  ```powershell
  python build_context.py index --verbose
  # Watch for errors
  # Note: How many documents indexed
  ```

- [ ] **Generate hot context**
  ```powershell
  python build_context.py generate --verbose
  # Creates .cursor/rules/context-hot.mdc
  ```

- [ ] **Review output file**
  ```powershell
  cat C:\DEV\.cursor\rules\context-hot.mdc
  ```

- [ ] **Verify output quality:**
  - [ ] File size <12KB
  - [ ] Contains relevant chunks
  - [ ] Formatting is clean
  - [ ] Source references are correct
  - [ ] Metadata header is present

- [ ] **Test in Cursor**
  - [ ] Restart Cursor
  - [ ] Create new chat
  - [ ] Ask about a standard (e.g., "What auth pattern do we use?")
  - [ ] Verify Cursor knows the answer without you saying

### Day 3: Automation Setup (2 hours)

- [ ] **Create refresh script**
  - [ ] Already exists: `C:\DEV\tools\context-builder\refresh.ps1`
  - [ ] Review and customize if needed

- [ ] **Test refresh script**
  ```powershell
  cd C:\DEV\tools\context-builder
  .\refresh.ps1
  # Should complete without errors
  ```

- [ ] **Schedule nightly refresh**
  ```powershell
  $action = New-ScheduledTaskAction `
      -Execute "pwsh.exe" `
      -Argument "-File C:\DEV\tools\context-builder\refresh.ps1" `
      -WorkingDirectory "C:\DEV\tools\context-builder"

  $trigger = New-ScheduledTaskTrigger -Daily -At 3am

  $settings = New-ScheduledTaskSettingsSet `
      -AllowStartIfOnBatteries `
      -DontStopIfGoingOnBatteries `
      -StartWhenAvailable

  Register-ScheduledTask `
      -TaskName "CursorHotContextRefresh" `
      -Action $action `
      -Trigger $trigger `
      -Settings $settings `
      -Description "Refresh Cursor hot context nightly" `
      -User $env:USERNAME `
      -RunLevel Highest
  ```

- [ ] **Verify scheduled task**
  ```powershell
  Get-ScheduledTask -TaskName "CursorHotContextRefresh" | fl
  ```

- [ ] **Set up git hook** (optional but recommended)
  ```bash
  # Create .git/hooks/post-commit
  cat > .git/hooks/post-commit << 'EOF'
  #!/bin/bash
  if git diff --name-only HEAD~1 | grep -qE '^docs/|README.md'; then
      echo "📝 Docs changed, regenerating hot context..."
      cd tools/context-builder || exit 1
      python build_context.py refresh
  fi
  EOF

  chmod +x .git/hooks/post-commit
  ```

- [ ] **Test git hook**
  ```powershell
  # Edit a doc
  echo "`n# Test" >> docs\test.md
  git add docs\test.md
  git commit -m "test: trigger hook"
  # Should see "📝 Docs changed..."
  ```

### Success Criteria

- [ ] Qdrant running and responding
- [ ] Ollama running with nomic-embed-text model
- [ ] context-hot.mdc file exists
- [ ] File size <12KB
- [ ] Contains relevant, recent content
- [ ] Nightly refresh scheduled
- [ ] Git hook working (if implemented)
- [ ] Cursor uses hot context automatically

---

## Phase 3: Integration & Monitoring (Week 3)

**Goal:** Unified system management
**Time:** 8 hours

### Unified Documentation (3 hours)

- [ ] **Add Complete System Guide to MkDocs**
  ```yaml
  # Edit mkdocs.yml
  nav:
    - Home: index.md
    - Complete System Guide: COMPLETE_SYSTEM_GUIDE.md
    - Vector Systems: VECTOR_SYSTEMS_INTEGRATION.md
    - Implementation: IMPLEMENTATION_CHECKLIST.md
    - Architecture:
        - Overview: architecture/README.md
        - Decisions: architecture/decisions/
  ```

- [ ] **Restart MkDocs**
  ```powershell
  cd C:\DEV
  mkdocs serve
  ```

- [ ] **Verify documentation accessible**
  - [ ] Open http://localhost:8000
  - [ ] Navigate to Complete System Guide
  - [ ] Verify all links work
  - [ ] Search functionality works

- [ ] **Create quick reference card**
  ```markdown
  # Quick Reference

  ## URLs
  - Backstage: http://localhost:3000
  - MkDocs: http://localhost:8000
  - Structurizr: http://localhost:8081
  - Sourcegraph: http://localhost:7080
  - VECTOR_MGMT: http://localhost:8765
  - Qdrant: http://localhost:6333
  - Ollama: http://localhost:11434

  ## Commands
  - Start all: .\scripts\up.ps1
  - Stop all: .\scripts\down.ps1
  - Check health: .\scripts\check-all.ps1
  - Refresh context: cd tools\context-builder && python build_context.py refresh
  - Search history: curl "http://localhost:8765/search?q=QUERY&k=5"

  ## Files
  - Hot context: C:\DEV\.cursor\rules\context-hot.mdc
  - System guide: C:\DEV\docs\COMPLETE_SYSTEM_GUIDE.md
  - Status: C:\DEV\STATUS.md
  ```

- [ ] **Save to:** `C:\DEV\QUICK_REFERENCE.md`

### Status Dashboard (3 hours)

- [ ] **Create status script**
  - [ ] Already exists: `C:\DEV\scripts\check-all.ps1`
  - [ ] Test it:
    ```powershell
    .\scripts\check-all.ps1
    ```

- [ ] **Enhance status script** (optional)
  - [ ] Add vector service checks
  - [ ] Add hot context age check
  - [ ] Add token usage stats
  - [ ] Color-code output

- [ ] **Create web dashboard** (optional advanced feature)
  - [ ] `C:\DEV\infra\status-dashboard\index.html`
  - [ ] Simple HTML + JavaScript
  - [ ] Polls service endpoints every 5 seconds
  - [ ] Shows green/red status

- [ ] **Add monitoring to startup routine**
  ```powershell
  # Edit: C:\DEV\scripts\morning-check.ps1
  Write-Host "Good morning! Checking system health..." -ForegroundColor Cyan
  .\scripts\check-all.ps1
  .\scripts\check-vectors.ps1
  ```

### Backup Strategy (2 hours)

- [ ] **Create backup script**
  - [ ] Already exists: `C:\DEV\scripts\backup-vectors.ps1`
  - [ ] Test it:
    ```powershell
    .\scripts\backup-vectors.ps1
    ```

- [ ] **Verify backup contains:**
  - [ ] Qdrant data
  - [ ] Hot context settings
  - [ ] VECTOR_MGMT databases
  - [ ] Current context-hot.mdc file

- [ ] **Schedule weekly backups**
  ```powershell
  $action = New-ScheduledTaskAction `
      -Execute "pwsh.exe" `
      -Argument "-File C:\DEV\scripts\backup-vectors.ps1"

  $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At 4am

  Register-ScheduledTask `
      -TaskName "VectorSystemsBackup" `
      -Action $action `
      -Trigger $trigger `
      -Description "Weekly backup of vector databases"
  ```

- [ ] **Test backup recovery** (critical!)
  ```powershell
  # Simulate disaster: Delete qdrant data
  docker stop qdrant
  Remove-Item C:\DEV\infra\vector-services\data\qdrant\* -Recurse -Force

  # Restore from backup
  $latestBackup = Get-ChildItem C:\DEV\backups\vectors\ | Sort-Object -Descending | Select-Object -First 1
  tar -xzf "$latestBackup\qdrant-*.tar.gz" -C C:\DEV\infra\vector-services\data\qdrant\

  # Restart and verify
  docker start qdrant
  Start-Sleep -Seconds 10
  curl http://localhost:6333/collections
  # Should show collections restored
  ```

### Success Criteria

- [ ] All documentation in MkDocs
- [ ] Status monitoring working
- [ ] Backup script functional
- [ ] Backup recovery tested
- [ ] Quick reference available
- [ ] Morning check routine established

---

## Phase 4: Token Tracking & Optimization (Week 4)

**Goal:** Measure and optimize ROI
**Time:** 4 hours

### Token Tracking Setup (2 hours)

- [ ] **Create token logging script**
  - [ ] Already provided in Complete System Guide
  - [ ] Location: `C:\DEV\scripts\track-tokens.ps1`

- [ ] **Test token logging**
  ```powershell
  .\scripts\track-tokens.ps1 -Tokens 57000 -Type "with-system" -Notes "Test chat"
  ```

- [ ] **Create reporting script**
  ```powershell
  # C:\DEV\scripts\token-report.ps1
  # Generates weekly summary
  ```

- [ ] **Log baseline data** (if you haven't already)
  ```powershell
  # Record several chats without the system
  .\scripts\track-tokens.ps1 -Tokens 200000 -Type "baseline" -Notes "Manual context"
  ```

- [ ] **Log with-system data**
  ```powershell
  # Use Cursor normally for a week, logging each chat
  # After each significant chat:
  .\scripts\track-tokens.ps1 -Tokens [ACTUAL] -Type "with-system"
  ```

### Optimization (2 hours)

- [ ] **Analyze token usage**
  ```powershell
  .\scripts\token-report.ps1
  # Review weekly summary
  ```

- [ ] **If savings <50%, optimize:**

  **Hot Context:**
  - [ ] Increase `relevance_threshold` in settings.yaml
  - [ ] Reduce `top_k` if context too verbose
  - [ ] Refine queries to be more specific
  - [ ] Test and measure

  **VECTOR_MGMT:**
  - [ ] Reduce result count in `query_vect_api.ps1`
  - [ ] Adjust query string (more specific)
  - [ ] Filter by recency (last 30 days)
  - [ ] Format more concisely

  **Context Injection:**
  - [ ] Shorten injected format
  - [ ] Use bullet points vs paragraphs
  - [ ] Include only essential info

- [ ] **Re-measure after optimizations**

- [ ] **Document optimal settings**
  ```markdown
  # Optimal Settings (2025-10-27)

  ## Hot Context
  - top_k: 10
  - relevance_threshold: 0.7
  - queries: [list]

  ## VECTOR_MGMT
  - result_count: 5
  - query: "recent work"
  - format: bullet points

  ## Results
  - Baseline: 200K tokens/chat
  - With system: 57K tokens/chat
  - Savings: 71.5%
  - Weekly cost: $114 (down from $400)
  ```

### Success Criteria

- [ ] Token usage tracked consistently
- [ ] Weekly reports generated
- [ ] Savings ≥60% vs baseline
- [ ] Optimal settings documented
- [ ] ROI visible and positive

---

## Final Verification

### Complete System Test

- [ ] **Restart computer** (clean slate)

- [ ] **Verify automatic startup:**
  - [ ] VECTOR_MGMT running (check port 8765)
  - [ ] Auto-injection monitoring active
  - [ ] Qdrant running (check port 6333)
  - [ ] Ollama running (check port 11434)

- [ ] **Check Project Context OS:**
  - [ ] Backstage: http://localhost:3000
  - [ ] MkDocs: http://localhost:8000
  - [ ] Structurizr: http://localhost:8081
  - [ ] Sourcegraph: http://localhost:7080 (may need manual start)

- [ ] **Test complete workflow:**
  1. [ ] Open Cursor
  2. [ ] Press Ctrl+N (new chat)
  3. [ ] Verify context auto-injects
  4. [ ] Ask a question about your system
  5. [ ] Verify Cursor has correct context
  6. [ ] Reference: "Check Backstage for X"
  7. [ ] Verify Cursor understands

- [ ] **Run all health checks:**
  ```powershell
  .\scripts\check-all.ps1
  .\scripts\check-vectors.ps1
  ```

- [ ] **Verify backups scheduled:**
  ```powershell
  Get-ScheduledTask | Where-Object {$_.TaskName -like "*vector*"}
  # Should show CursorHotContextRefresh and VectorSystemsBackup
  ```

### Success Criteria - Complete System

- [ ] All services start automatically
- [ ] Hot context <24 hours old
- [ ] VECTOR_MGMT API responding
- [ ] Auto-injection working
- [ ] Project Context OS accessible
- [ ] Token savings ≥60%
- [ ] Backups scheduled
- [ ] Documentation complete
- [ ] No errors in logs

---

## Rollback Plan (If Needed)

If something goes wrong:

### Disable Auto-Injection
```powershell
# Kill processes
Get-Process | Where-Object {$_.Name -like "*autohotkey*"} | Stop-Process
Get-Process | Where-Object {$_.Name -like "*t2_proc*"} | Stop-Process

# Remove from startup
Remove-Item "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\start-vector-mgmt.ps1"
```

### Disable Hot Context
```powershell
# Remove file
Remove-Item C:\DEV\.cursor\rules\context-hot.mdc

# Disable scheduled task
Disable-ScheduledTask -TaskName "CursorHotContextRefresh"

# Stop Docker
docker stop qdrant ollama
```

### Stop VECTOR_MGMT
```powershell
cd C:\AI_Coding\00_SYSTEM\01_INFRASTRUCTURE\00_VECTOR_MGMT\40_RUNTIME
.\STOP_VEC_MGMT.ps1
```

### Restore from Backup
```powershell
# See backup script for restore procedure
.\scripts\restore-vectors.ps1 -BackupDate "2025-10-27"
```

---

## Maintenance Schedule

### Daily (Automated)
- [x] Hot context refresh (3 AM)
- [x] VECTOR_MGMT extraction (continuous)

### Weekly (5 min)
- [ ] Monday: Run health checks
- [ ] Review token usage
- [ ] Clean scratch folder

### Monthly (30 min)
- [ ] Update Docker images
- [ ] Review and clean old backups
- [ ] Check Qdrant collection sizes
- [ ] Update dependencies

---

## Support & Documentation

**For help, see:**
- Complete System Guide: `C:\DEV\docs\COMPLETE_SYSTEM_GUIDE.md`
- Vector Integration: `C:\DEV\docs\VECTOR_SYSTEMS_INTEGRATION.md`
- Quick Reference: `C:\DEV\QUICK_REFERENCE.md`
- Status: `C:\DEV\STATUS.md`
- This Checklist: `C:\DEV\docs\IMPLEMENTATION_CHECKLIST.md`

**Common Issues:**
- See Complete System Guide Part 6: Troubleshooting
- See Vector Integration: Troubleshooting section

---

## Completion Tracking

**Phase 1 Complete:** _____ (Date)
**Phase 2 Complete:** _____ (Date)
**Phase 3 Complete:** _____ (Date)
**Phase 4 Complete:** _____ (Date)

**Total Time Spent:** _____ hours
**Token Savings Achieved:** _____ %
**Weekly Cost Before:** $ _____
**Weekly Cost After:** $ _____
**Weekly Savings:** $ _____
**Annual Projected Savings:** $ _____

**Notes:**
- What went well:
- What was difficult:
- Optimizations made:
- Recommendations for future:

---

**System Status:** [ ] Not Started  [ ] In Progress  [ ] Complete

**Sign-off:** _______________  **Date:** _______________
