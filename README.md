# DHANYAS BOUTIQUE — POS & Inventory Billing System

A PWA-enabled Point of Sale (POS), billing, and inventory management system for **Dhanyas Boutique**, Kumbakonam. It handles quick invoice generation, WhatsApp delivery of digital receipts, order history, GST / non-GST billing with two revenue dashboards, stock management with low-stock alerts, and an editable shop profile.

## Features

### ⚙️ Shop Settings (Admin only)
- Edit the shop profile used everywhere: owner name, shop name, tagline, phone, email, address, city, business hours, Instagram link and GSTIN
- Upload or reset the **shop logo** (auto-resized to 512px and stored with the profile)
- Edit the **product catalogue** inline — add, rename, re-price, change GST % / HSN, delete items
- Create catalogue categories without leaving the screen
- Changes flow straight to the public store page (`/`), printed invoices/receipts, the PWA manifest and app icon
- The `shop_settings` table is created automatically on first run — no manual migration needed

### 🧾 POS Billing Panel
- Quick invoice generator with a searchable product catalog
- Add custom items with price and quantity controls
- Manual discounts (fixed ₹ or percent %)
- **GST Invoice / Non-GST Bill toggle** at the point of billing
- **Changeable GST %** — pre-filled from each product's default GST rate, editable per sale
- Optional delivery fee
- Cash payment tracking with auto-calculated change return
- Backdate support (custom / past bill dates)
- Online / Offline (POS) order source toggle
- Send the bill directly to the customer via WhatsApp with a digital invoice link

### 📦 Inventory (Admin only)
- Full CRUD on the catalogue — **products and services** in one list
- **Product ⇄ Service switch** at the top of the item form. Services (delivery, packing, add-ons, alteration charges) support price, cost, GST, HSN, offers and notes but carry **no stock**
- Per-item **cost price** (records only, never used in billing) and **Active** flag (inactive items are hidden from the Billing Panel)
- **Stock tracking** on products with a **low-stock alert** that flags the row in red
- Stock is **decremented automatically** when a bill is completed; services are skipped
- **Automatic offers** — set an offer % and price once, and it is applied automatically whenever the item is added to a bill and shown on the invoice
- Per-product **GST rate** (used to pre-fill GST at billing) and **HSN code**
- Export the complete catalogue to CSV (type, cost, stock, low-stock alert, offer and active status included)

### 📜 Order History
- Search orders by ID, customer name, or phone number
- Filter by source (Online / Offline) and status
- Period filters (All Time, Today, Week, Month, Year, Custom range)
- View detailed order modal
- Print / download invoice as PDF
- Resend invoice via WhatsApp
- Export filtered orders to CSV (admin only)
- Delete invoices (admin only)

### 📊 Analytics — GST & Non-GST Dashboards (Admin only)
- Switch the whole dashboard between **All Bills / GST Invoices / Non-GST Bills**
- KPIs: total revenue, completed bills, online/offline split, items sold, avg order value
- Today's Sales, monthly & weekly revenue trends
- Product sales leaderboard with market share
- Coupon / promo campaign performance tracking
- Custom period filters and contact/invoice search

### 📱 PWA & Mobile
- Installable as a standalone app
- Offline-first service worker with network-first caching
- Responsive mobile-friendly UI

## Tech Stack

- Next.js 16 (App Router)
- React 19
- TypeScript
- Tailwind CSS v4
- Neon Serverless PostgreSQL (`@neondatabase/serverless`)
- lucide-react (icons)

## Getting Started

### 1. Install

```bash
npm install
```

### 2. Configure Environment Variables

Create a `.env.local` file in the project root:

```env
ADMIN_PASSCODE=your-admin-passcode
STAFF_PASSCODE=your-staff-passcode
DATABASE_URL=postgresql://user:password@hostname/dbname?sslmode=require
```

### 3. Set up the database

Run `schema.sql` once in your Neon SQL Editor (or `psql`) to create a clean, empty database. Optionally run `seed.sql` afterwards to load some sample mobile-shop data.

### 4. Run the Development Server

```bash
npm run dev
```

Open http://localhost:3000.

- Public store page: `/`
- POS terminal: `/pos/admin/secure/control-panel/ss-creatives`
- Digital invoice: `/invoice/[invoice-id]`

## Data Model

- **shop_settings** — single row (`id = 'default'`) holding the shop profile: owner name, shop name, tagline, phone, email, address, city, business hours, Instagram link, GSTIN and the uploaded logo (stored as a data URL).
- **products** — the catalogue. Rows are either `PRODUCT` (physical, stock-tracked) or `SERVICE` (non-stocked add-ons). Each row carries `selling_price`, `cost_price`, `gst_rate`, `hsn_code`, `current_stock` / `low_stock_alert` (NULL for services), `offer_discount_pct` / `offer_price` and `is_active`.
- **order_items** — invoice lines, snapshotting name, price, quantity and the `offer_pct` that was applied.
- **customers**, **orders**, **order_items** — sales records. `orders.is_gst` flags GST invoices vs non-GST bills, which powers the two revenue dashboards.

See `schema.sql` for the full schema.

## Roles

- **Staff** — Billing Panel, Order History (view-only).
- **Admin** — Full access, including Inventory CRUD, Shop Settings, Analytics, and delete permissions.

The role is determined by which passcode is used to log in.

## License

© 2026 Dhanyas Boutique. All Rights Reserved.

Powered by [Cenexa Systems](https://www.cenexasystems.com/).
