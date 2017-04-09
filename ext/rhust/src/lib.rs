#[macro_use]
extern crate ruru;

use ruru::{Class, Object, Fixnum};

class!(Rhust);

methods!(
    Rhust,
    _itself,

    fn val() -> Fixnum {
        Fixnum::new(42)
    }
);

#[no_mangle]
#[allow(non_snake_case)]
pub extern fn Init_rhust() {
    Class::from_existing("Rhust").define(|itself| {
        itself.define_singleton_method("val", val);
    });
}
