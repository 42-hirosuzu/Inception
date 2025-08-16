<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * Localized language
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wpuser' );

/** Database password */
define( 'DB_PASSWORD', 'password' );

/** Database hostname */
define( 'DB_HOST', 'db:3306' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',          'V2z|r{r2GJ2L(ruVc^C]4~B]2Q`NPc>R|S}B+Two[liX]%^/-D#{>)KNl)Di|wjM' );
define( 'SECURE_AUTH_KEY',   '9}:P_m1(.DJrdWjgv]<rNeHs{|DDC+EaWLpr:Mn^c.Tm+%qJ@x>O:{2p:w? aQ,<' );
define( 'LOGGED_IN_KEY',     ':J+0}R&tZX eHcz&j=XicZ/i1bPI[4-Om}+8}8r6X3BMU``_8.S)IEE^JA9PL-9p' );
define( 'NONCE_KEY',         'D$7TG~[C!wE`>=^uGhw,l%/j)^rCX)(f:A$RrCS>ouDQ<?.-ZNDnVcVGP-%uB@fk' );
define( 'AUTH_SALT',         'wUmZ$vFKY/vY&J!w<Zv5RdD$U+oEK:*AzZRg*7~GSl^T*mfhy=W-BvJUXiam$?JB' );
define( 'SECURE_AUTH_SALT',  'YH35iHmNY@7^yG|<-uV~qo}A<LI9tkdq <FUr33NA%0nXxV@lbJ/cxKc~Xx%J]jr' );
define( 'LOGGED_IN_SALT',    'Aqo!Z_S2^{V]ro] dg)0uM~`T5G)(eg*P,^b8Sh0R{i!gl5;66L-Y$f~qZBvu>d9' );
define( 'NONCE_SALT',        'gj:!4{W)4Ty_nOLa~1L9pE@f[YJ!:+g/ihgT7@h|]#uQ>_3jjLpUGU1W)$M@7*}v' );
define( 'WP_CACHE_KEY_SALT', 'Yc9gMQ5L_>TY bkbK6>0#$(p.xb!3;wdpP#|34L;+-qf8%Y8R5W?METxAvNDWD>V' );


/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';


/* Add any custom values between this line and the "stop editing" line. */



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
if ( ! defined( 'WP_DEBUG' ) ) {
	define( 'WP_DEBUG', false );
}

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
