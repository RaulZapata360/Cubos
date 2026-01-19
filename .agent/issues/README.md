# Known Issues - Quick Reference

## 🔴 Active Issues

### 1. Material Breakdown Not Populating
**File:** `.agent/issues/material-breakdown-not-populating.md`  
**Status:** Pending Investigation  
**Priority:** Medium  
**Date:** 2026-01-19

**Summary:** The material breakdown sections in operation cards show "Sin movimientos registrados" instead of actual material data. The HTML elements exist but there's no JavaScript function to populate them with movement data grouped by material type.

**Affected Elements:**
- `incomingMaterialBreakdown`
- `internalMaterialBreakdown`
- `outgoingMaterialBreakdown`

**Action Required:** Implement `updateMaterialBreakdowns()` function to query, group, and display material data from Supabase.

---

## 🟢 Resolved Issues

_(No resolved issues yet)_

---

## 📋 Issue Tracking Guidelines

1. **Create Issue:** Add detailed markdown file in `.agent/issues/`
2. **Update Status:** Move from Active to Resolved when fixed
3. **Reference:** Link to issue file in commit messages
4. **Close:** Archive resolved issues to `.agent/issues/resolved/`

---

**Last Updated:** 2026-01-19
