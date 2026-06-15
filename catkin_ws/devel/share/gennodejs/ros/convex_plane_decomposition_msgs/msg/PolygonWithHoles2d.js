// Auto-generated. Do not edit!

// (in-package convex_plane_decomposition_msgs.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let Polygon2d = require('./Polygon2d.js');

//-----------------------------------------------------------

class PolygonWithHoles2d {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.outer_boundary = null;
      this.holes = null;
    }
    else {
      if (initObj.hasOwnProperty('outer_boundary')) {
        this.outer_boundary = initObj.outer_boundary
      }
      else {
        this.outer_boundary = new Polygon2d();
      }
      if (initObj.hasOwnProperty('holes')) {
        this.holes = initObj.holes
      }
      else {
        this.holes = [];
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type PolygonWithHoles2d
    // Serialize message field [outer_boundary]
    bufferOffset = Polygon2d.serialize(obj.outer_boundary, buffer, bufferOffset);
    // Serialize message field [holes]
    // Serialize the length for message field [holes]
    bufferOffset = _serializer.uint32(obj.holes.length, buffer, bufferOffset);
    obj.holes.forEach((val) => {
      bufferOffset = Polygon2d.serialize(val, buffer, bufferOffset);
    });
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type PolygonWithHoles2d
    let len;
    let data = new PolygonWithHoles2d(null);
    // Deserialize message field [outer_boundary]
    data.outer_boundary = Polygon2d.deserialize(buffer, bufferOffset);
    // Deserialize message field [holes]
    // Deserialize array length for message field [holes]
    len = _deserializer.uint32(buffer, bufferOffset);
    data.holes = new Array(len);
    for (let i = 0; i < len; ++i) {
      data.holes[i] = Polygon2d.deserialize(buffer, bufferOffset)
    }
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += Polygon2d.getMessageSize(object.outer_boundary);
    object.holes.forEach((val) => {
      length += Polygon2d.getMessageSize(val);
    });
    return length + 4;
  }

  static datatype() {
    // Returns string type for a message object
    return 'convex_plane_decomposition_msgs/PolygonWithHoles2d';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '62e09666eefc245f9ca3347875cb36cc';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    # Specification of a 2D polygon with holes
    Polygon2d outer_boundary
    Polygon2d[] holes
    ================================================================================
    MSG: convex_plane_decomposition_msgs/Polygon2d
    # Specification of a 2D polygon where the first and last points are connected
    Point2d[] points
    ================================================================================
    MSG: convex_plane_decomposition_msgs/Point2d
    float32 x
    float32 y
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new PolygonWithHoles2d(null);
    if (msg.outer_boundary !== undefined) {
      resolved.outer_boundary = Polygon2d.Resolve(msg.outer_boundary)
    }
    else {
      resolved.outer_boundary = new Polygon2d()
    }

    if (msg.holes !== undefined) {
      resolved.holes = new Array(msg.holes.length);
      for (let i = 0; i < resolved.holes.length; ++i) {
        resolved.holes[i] = Polygon2d.Resolve(msg.holes[i]);
      }
    }
    else {
      resolved.holes = []
    }

    return resolved;
    }
};

module.exports = PolygonWithHoles2d;
