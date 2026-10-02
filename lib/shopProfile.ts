import type { ShopSettings } from './types';

/**
 * Default shop profile. These values are seeded into the database on first run
 * and used as a fallback whenever the database is unreachable.
 *
 * This module is intentionally free of any database import so it can also be
 * used from client components.
 */
export const DEFAULT_SHOP_SETTINGS: ShopSettings = {
  owner_name: 'Ananthi M',
  shop_name: 'Dhanyas Boutique',
  tagline: 'Designer Wear • Tailoring • Alterations • Embroidery',
  phone: '8098089591',
  email: 'dhanyasboutique2015@gmail.com',
  address: 'Kasthoribhai road, AGM Apartment, Kumbakonam - 612001',
  location: 'Kumbakonam, Tamil Nadu',
  instagram_url: 'https://www.instagram.com/ananthinathan84',
  business_hours: 'Open Daily',
  services:
    'Custom Tailoring • Designer Blouses & Dresses • Alterations & Fittings • Embroidery & Aari Work • Boutique Wear',
  gstin: '',
  logo_data_url: null,
};

/** Logo src to render: uploaded logo when present, otherwise the bundled asset. */
export const shopLogoSrc = (settings: ShopSettings): string =>
  settings.logo_data_url || '/logo.svg';

/** Phone split for invoice headers, e.g. 8098089591 -> +91 80980 89591 */
export const formatPhone = (phone: string): string => {
  const digits = (phone || '').replace(/\D/g, '');
  const local = digits.length > 10 ? digits.slice(-10) : digits;
  if (local.length !== 10) return phone || '';
  return `+91 ${local.slice(0, 5)} ${local.slice(5)}`;
};
