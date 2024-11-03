/**
 * Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
 * Licensed under the EUPL-1.2-or-later.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * SPDX-License-Identifier: EUPL-1.2
 */

import nextra from 'nextra'
 
const withNextra = nextra({
  theme: 'nextra-theme-docs',
  themeConfig: './theme.config.jsx'
})
 
export default withNextra()