#[macro_use]
extern crate ruru;

use ruru::{Boolean, Class, Object, RString, Fixnum};

class!(Rhust);

methods!(
    Rhust,
    itself,

    fn val() -> Fixnum {
        Fixnum::new(42)
    }
);

#[no_mangle]
pub extern fn Init_rhust() {
    Class::from_existing("Rhust").define(|itself| {
        itself.define_singleton_method("val", val);
    });
}
