# Issue: Material Breakdown Not Populating

**Status:** 🔴 Pending Investigation  
**Priority:** Medium  
**Date Reported:** 2026-01-19  
**Reported By:** User

## Description

The material breakdown sections in the operation cards are not being populated with data. The HTML elements exist and are correctly structured, but they remain showing the placeholder text "Sin movimientos registrados" even when there are movements in the system.

## Affected Components

### HTML Elements (index.html)
Three material breakdown containers exist:

1. **Incoming Material Breakdown** (line ~526)
   - Element ID: `incomingMaterialBreakdown`
   - Placeholder: "Sin movimientos registrados"
   - Location: Inside the green "ENTRADA DE MATERIAL" card

2. **Internal Material Breakdown** (line ~571)
   - Element ID: `internalMaterialBreakdown`
   - Placeholder: "Sin registros"
   - Location: Inside the blue "VIAJE INTERNO" card

3. **Outgoing Material Breakdown** (line ~614)
   - Element ID: `outgoingMaterialBreakdown`
   - Placeholder: "Sin registros"
   - Location: Inside the red "SALIDA MATERIAL" card

## Expected Behavior

Each operation card should display a breakdown of materials moved, showing:
- Material name
- Volume (m³) for each material
- Visual indicators (badges/chips) for each material type

Example expected output:
```
🟢 Ripio: 150.5 m³
🟡 Arena: 87.2 m³
🔵 Grava: 74.3 m³
```

## Current Behavior

All three breakdown sections show only the placeholder text:
- "Sin movimientos registrados" (incoming)
- "Sin registros" (internal and outgoing)

## Root Cause Analysis

### Missing Functionality
There is **no JavaScript function** currently implemented to:
1. Fetch movement data grouped by material type
2. Calculate totals per material
3. Update the breakdown DOM elements
4. Clear the placeholder text when data is available

### Required Implementation

A function similar to this needs to be created:

```javascript
async function updateMaterialBreakdowns() {
    // For each movement type (incoming, outgoing, internal)
    // 1. Query movements from Supabase filtered by:
    //    - obra_id
    //    - fecha (current counter date)
    //    - tipo (incoming/outgoing/internal)
    // 2. Group by material_id
    // 3. Sum volumes per material
    // 4. Render breakdown chips/badges
    // 5. Replace placeholder text
}
```

## Data Source

Movements are stored in Supabase `movimientos` table with structure:
- `id`
- `obra_id`
- `camion_id`
- `material_id` (FK to `materiales` table)
- `origen_id`
- `destino_id`
- `fecha`
- `hora`
- `volumen_m3`
- `tipo` (incoming/outgoing/internal)

Materials are in `materiales` table:
- `id`
- `nombre`
- `tipo` (incoming/outgoing)
- `obra_id`

## Integration Points

The function should be called:
1. On page load (after movements are loaded)
2. After adding a new movement
3. After deleting a movement
4. When changing the counter date
5. When changing the selected obra

## Technical Notes

- The breakdown should respect the current `counterDate` global variable
- Should filter by the current `obraId`
- Should handle the case when no movements exist (keep placeholder)
- Should use the same styling as other UI elements (glassmorphism, proper colors)
- Consider adding icons or color coding per material type

## Related Code Locations

- **HTML Structure:** `index.html` lines 524-529, 569-574, 612-617
- **Movement Loading:** Search for where movements are currently loaded
- **Date Filtering:** Look for `counterDate` usage
- **Obra Filtering:** Look for `obraId` usage

## Suggested Color Scheme for Materials

Based on existing design:
- Incoming materials: Green tones (emerald)
- Outgoing materials: Red/Rose tones
- Internal materials: Blue tones
- Material badges: Use `bg-white/10` with colored text

## Testing Checklist

Once implemented, verify:
- [ ] Breakdown shows correct materials for incoming movements
- [ ] Breakdown shows correct materials for outgoing movements
- [ ] Breakdown shows correct materials for internal movements
- [ ] Volumes are correctly summed per material
- [ ] Placeholder text is hidden when data exists
- [ ] Placeholder text shows when no movements exist
- [ ] Updates when date changes
- [ ] Updates when obra changes
- [ ] Updates after adding new movement
- [ ] Updates after deleting movement

## Dependencies

- Supabase client (already initialized)
- Access to `movimientos` table
- Access to `materiales` table
- Global variables: `counterDate`, `obraId`

## Estimated Effort

- **Development:** 2-3 hours
- **Testing:** 1 hour
- **Total:** 3-4 hours

## Notes

This is a **separate issue** from the current work on header icons and obra name badge. It should be addressed in a future session to avoid scope creep.

---

**Screenshot Reference:** User provided screenshot showing "Sin movimientos registrados" in the operation cards.
