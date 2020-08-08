<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'rde-vrie' );

/** MySQL database password */
define( 'DB_PASSWORD', 'hello' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '[sd>0wL+YqB-`X,a,!7V@.SW]l~(-/G0A9Buf,=UP-CUn3{[AuBEe7ytY{|kyJH9');
define('SECURE_AUTH_KEY',  'RTH|SjX  *7;MMgJ%5D)g|[7L{GeWU8KpNs1]+LE0y4!oFW*hC$.vlZNotU!,Hj_');
define('LOGGED_IN_KEY',    '>(~0<|D(wi=4(:2(L]J=69,HfB|A/Gss*`*^*]?$C4Qt3Q9WUz%]3{N~{>zG;lJg');
define('NONCE_KEY',        't7P#eYF*&fQq(qszD: ~zRE0|kmP_-#l-n+?&1x,#+/B8fO;}mqrs9uOuKD.{byO');
define('AUTH_SALT',        'eRB.g0)rOsT&d)58/e`k5^Irt`IB~3c?rm^Qm*S1aM_f*-9:@:!{Yz]{b+hqn]ZS');
define('SECURE_AUTH_SALT', 'LT@8`NO~=)FqLs%1|$ov-Tea.x|ZA(]Zte[c4voWCWdT2NFnz=U>DE4xEJjnJksw');
define('LOGGED_IN_SALT',   'h}z>Wa6%%@ EIs~Gh82_kEr40T:j%,u|6(h%BvGY:#,pXn9N|@R|chU11e9L}nDD');
define('NONCE_SALT',       '<YKOfmK[N7V2)Vy][6i3|b_|O&Dm>7,O;N;3{g nnG3-ujv].&+_EQ5r|9mWY|hs');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	#define( 'ABSPATH', __DIR__ . '/' );
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );
