#[macro_use]
extern crate ruru;
#[macro_use]
extern crate lazy_static;

use ruru::{Class, Object, Fixnum, AnyObject};

pub struct RRhust
{
    state: i64,
}

impl RRhust
{
    fn new() -> Self {
        RRhust {
            state: 0,
        }
    }
}

wrappable_struct!(RRhust, RhustWrapper, RHUST_WRAPPER);

class!(Rhust);

methods!(
    Class,
    it,

    fn rhust_new() -> AnyObject
    {
        it.wrap_data(
            RRhust::new(),
            &*RHUST_WRAPPER,
        )
    }

);

methods!(
    Rhust,
    it,

    fn rhust_incr() -> Fixnum
    {
        let rrhust = it.get_data(&*RHUST_WRAPPER);
        rrhust.state += 1;
        Fixnum::new(rrhust.state)
    }

    fn rhust_get() -> Fixnum
    {
        let rrhust = it.get_data(&*RHUST_WRAPPER);
        Fixnum::new(rrhust.state)
    }

    fn rhust_reset() -> Fixnum
    {
        let rrhust = it.get_data(&*RHUST_WRAPPER);
        rrhust.state = 0;
        Fixnum::new(rrhust.state)
    }

);

#[no_mangle]
#[allow(non_snake_case)]
pub extern fn Init_rhust()
{
    // I know it's not a class, but ruru does not provide a method
    // to handle module.
    let mut m_rhust = Class::from_existing("Rhust");
    let mut rhust_class = m_rhust.define_nested_class("Rhust", None);
    rhust_class.define(|c| {
        c.def_self("new", rhust_new);
        c.def("incr", rhust_incr);
        c.def("get", rhust_get);
        c.def("reset", rhust_reset);
    });
}
