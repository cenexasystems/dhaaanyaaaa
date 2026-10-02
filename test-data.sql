-- =====================================================================
--  DHANYAS BOUTIQUE — TEST / DEMO CATALOGUE DATA
--  Target: PostgreSQL 15+ (Neon serverless)
--
--  HOW TO USE
--  1. Neon Console -> SQL Editor -> New Query
--  2. Paste this file and click Run
--
--  ---------------------------------------------------------------------
--  SAFE TO REMOVE
--  Every inserted row is tagged in TWO independent ways:
--    1. id starts with 'test-demo-'     -> allows a targeted delete
--    2. description starts with '[DEMO]' -> visible marker in the UI
--
--  The ROLLBACK block at the bottom removes ONLY rows carrying those tags.
--  Real products, orders, customers, invoices and categories are never
--  touched — the delete predicates cannot match them.
--
--  Re-running this file is safe: rows are matched on a fixed id, so a
--  second run UPDATES the same 9 rows instead of creating duplicates.
-- =====================================================================


-- STEP 1 — ensure the categories exist (no-op when already present) ------
INSERT INTO categories (id, name) VALUES
  ('test-demo-cat-sarees',   'Sarees'),
  ('test-demo-cat-blouses',  'Blouses'),
  ('test-demo-cat-dupattas', 'Dupattas')
ON CONFLICT (name) DO NOTHING;


-- STEP 2 — the demo catalogue -------------------------------------------
--  offer_price is derived in STEP 3 rather than hard-coded, so the discount
--  percentage and the resulting price can never drift apart. To change a
--  price or a discount, edit selling_price / offer_discount_pct only.
INSERT INTO products (
  id, name, description, category, gst_rate, hsn_code, selling_price,
  item_type, cost_price, current_stock, low_stock_alert,
  offer_discount_pct, offer_price, is_active
)
VALUES
  ('test-demo-01',
   'Kanjeevaram Silk Saree – Maroon',
   '[DEMO] Pure silk, gold zari border, traditional bridal design',
   'Sarees', 5, '5009', 8999, 'PRODUCT', 6200, 5, 2, 10, NULL, TRUE),

  ('test-demo-02',
   'Soft Silk Saree – Bottle Green',
   '[DEMO] Soft silk, antique zari, festive wear',
   'Sarees', 5, '5009', 4999, 'PRODUCT', 3400, 8, 2, 5, NULL, TRUE),

  ('test-demo-03',
   'Banarasi Silk Saree – Royal Blue',
   '[DEMO] Banarasi silk, floral zari weaving, wedding wear',
   'Sarees', 5, '5009', 6499, 'PRODUCT', 4500, 4, 1, 10, NULL, TRUE),

  ('test-demo-04',
   'Organza Saree – Lavender',
   '[DEMO] Lightweight organza, floral embroidery, party wear',
   'Sarees', 5, '5009', 3299, 'PRODUCT', 2100, 6, 2, 8, NULL, TRUE),

  ('test-demo-05',
   'Cotton Silk Saree – Mustard',
   '[DEMO] Cotton-silk blend, contrast zari border, daily/festive wear',
   'Sarees', 5, '5009', 2499, 'PRODUCT', 1600, 10, 3, 5, NULL, TRUE),

  ('test-demo-06',
   'Designer Silk Saree – Pink',
   '[DEMO] Rich pink silk, gold zari, embellished pallu',
   'Sarees', 5, '5009', 7499, 'PRODUCT', 5100, 3, 1, 12, NULL, TRUE),

  ('test-demo-07',
   'Bridal Blouse – Red & Gold',
   '[DEMO] Embroidered blouse, gold detailing, padded, size 38',
   'Blouses', 5, '6108', 2999, 'PRODUCT', 1850, 5, 2, 10, NULL, TRUE),

  ('test-demo-08',
   'Embroidered Blouse – Peacock Green',
   '[DEMO] Thread and zari embroidery, festive design, size 36',
   'Blouses', 5, '6108', 2499, 'PRODUCT', 1500, 7, 2, 5, NULL, TRUE),

  ('test-demo-09',
   'Designer Dupatta – Wine',
   '[DEMO] Net dupatta with zari border and stone embellishments',
   'Dupattas', 5, '6217', 1499, 'PRODUCT', 850, 12, 3, 10, NULL, TRUE)
ON CONFLICT (id) DO UPDATE SET
  name               = EXCLUDED.name,
  description        = EXCLUDED.description,
  category           = EXCLUDED.category,
  gst_rate           = EXCLUDED.gst_rate,
  hsn_code           = EXCLUDED.hsn_code,
  selling_price      = EXCLUDED.selling_price,
  cost_price         = EXCLUDED.cost_price,
  current_stock      = EXCLUDED.current_stock,
  low_stock_alert    = EXCLUDED.low_stock_alert,
  offer_discount_pct = EXCLUDED.offer_discount_pct,
  is_active          = EXCLUDED.is_active;


-- STEP 3 — derive offer_price from the discount percentage ---------------
--  Matches the POS rule: price billed = price x (1 - discount%).
UPDATE products
SET offer_price = ROUND(selling_price * (1 - offer_discount_pct / 100.0))
WHERE id LIKE 'test-demo-%'
  AND offer_discount_pct > 0;


-- STEP 4 — confirm what landed ------------------------------------------
SELECT name, category, selling_price, cost_price,
       current_stock, low_stock_alert,
       offer_discount_pct || '%', offer_price
FROM products
WHERE id LIKE 'test-demo-%'
ORDER BY name;


-- =====================================================================
--  ROLLBACK — uncomment and run to remove ONLY the demo rows.
--  Safe to run repeatedly. Cannot touch non-demo data.
--
--  About past invoices: order_items.product_id is ON DELETE SET NULL, so an
--  invoice that already used a demo product keeps its full history — the line
--  stores snapshot_name / snapshot_price independently — it only loses the
--  link back to the catalogue row. This is intentional: real sales records
--  are never destroyed by removing test data.
-- =====================================================================

-- DELETE FROM products
--  WHERE id LIKE 'test-demo-%'
--     OR description LIKE '[DEMO]%';

-- -- Remove the categories ONLY if this seed created them and nothing else uses them.
-- DELETE FROM categories c
--  WHERE c.id LIKE 'test-demo-cat-%'
--    AND NOT EXISTS (SELECT 1 FROM products p WHERE p.category = c.name);