module dos_pfp::pfp;

use dos_attribute::attribute::Attribute;
use std::string::String;
use sui::package::{Self, Publisher};
use sui::vec_map::{Self, VecMap};

//=== Structs ===

public struct PFP has drop {}

public struct Pfp<phantom T> has key, store {
    id: UID,
    name: String,
    number: u64,
    description: String,
    image_uri: String,
    attributes: VecMap<String, Attribute>,
}

//=== Errors ===

const EInvalidPublisher: u64 = 0;

//=== Init Function ===

fun init(otw: PFP, ctx: &mut TxContext) {
    let publisher = package::claim(otw, ctx);
    transfer::public_transfer(publisher, ctx.sender());
}

//=== Public Functions ===

public fun new<T>(
    publisher: &Publisher,
    name: String,
    number: u64,
    description: String,
    ctx: &mut TxContext,
): Pfp<T> {
    assert!(publisher.from_module<T>() == true, EInvalidPublisher);

    let pfp = Pfp {
        id: object::new(ctx),
        name: name,
        number: number,
        description: description,
        image_uri: b"".to_string(),
        attributes: vec_map::empty(),
    };

    pfp
}

public fun reveal_attributes<T>(pfp: &mut Pfp<T>, attributes: vector<Attribute>) {
    let attribute_keys = vector::tabulate!(attributes.length(), |i| attributes[i].key());
    pfp.attributes = vec_map::from_keys_values(attribute_keys, attributes);
}

public fun reveal_image<T>(pfp: &mut Pfp<T>, image_uri: String) {
    pfp.image_uri = image_uri;
}

public fun name<T>(pfp: &Pfp<T>): String {
    pfp.name
}

public fun number<T>(pfp: &Pfp<T>): u64 {
    pfp.number
}

public fun description<T>(pfp: &Pfp<T>): String {
    pfp.description
}

public fun image_uri<T>(pfp: &Pfp<T>): String {
    pfp.image_uri
}

public fun attributes<T>(pfp: &Pfp<T>): VecMap<String, Attribute> {
    pfp.attributes
}
