// Auto-generated. Do not edit!

// (in-package convex_plane_decomposition_msgs.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let BoundingBox2d = require('./BoundingBox2d.js');
let PolygonWithHoles2d = require('./PolygonWithHoles2d.js');
let geometry_msgs = _finder('geometry_msgs');

//-----------------------------------------------------------

class PlanarRegion {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.plane_parameters = null;
      this.bbox2d = null;
      this.boundary = null;
      this.insets = null;
    }
    else {
      if (initObj.hasOwnProperty('plane_parameters')) {
        this.plane_parameters = initObj.plane_parameters
      }
      else {
        this.plane_parameters = new geometry_msgs.msg.Pose();
      }
      if (initObj.hasOwnProperty('bbox2d')) {
        this.bbox2d = initObj.bbox2d
      }
      else {
        this.bbox2d = new BoundingBox2d();
      }
      if (initObj.hasOwnProperty('boundary')) {
        this.boundary = initObj.boundary
      }
      else {
        this.boundary = new PolygonWithHoles2d();
      }
      if (initObj.hasOwnProperty('insets')) {
        this.insets = initObj.insets
      }
      else {
        this.insets = [];
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type PlanarRegion
    // Serialize message field [plane_parameters]
    bufferOffset = geometry_msgs.msg.Pose.serialize(obj.plane_parameters, buffer, bufferOffset);
    // Serialize message field [bbox2d]
    bufferOffset = BoundingBox2d.serialize(obj.bbox2d, buffer, bufferOffset);
    // Serialize message field [boundary]
    bufferOffset = PolygonWithHoles2d.serialize(obj.boundary, buffer, bufferOffset);
    // Serialize message field [insets]
    // Serialize the length for message field [insets]
    bufferOffset = _serializer.uint32(obj.insets.length, buffer, bufferOffset);
    obj.insets.forEach((val) => {
      bufferOffset = PolygonWithHoles2d.serialize(val, buffer, bufferOffset);
    });
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type PlanarRegion
    let len;
    let data = new PlanarRegion(null);
    // Deserialize message field [plane_parameters]
    data.plane_parameters = geometry_msgs.msg.Pose.deserialize(buffer, bufferOffset);
    // Deserialize message field [bbox2d]
    data.bbox2d = BoundingBox2d.deserialize(buffer, bufferOffset);
    // Deserialize message field [boundary]
    data.boundary = PolygonWithHoles2d.deserialize(buffer, bufferOffset);
    // Deserialize message field [insets]
    // Deserialize array length for message field [insets]
    len = _deserializer.uint32(buffer, bufferOffset);
    data.insets = new Array(len);
    for (let i = 0; i < len; ++i) {
      data.insets[i] = PolygonWithHoles2d.deserialize(buffer, bufferOffset)
    }
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += PolygonWithHoles2d.getMessageSize(object.boundary);
    object.insets.forEach((val) => {
      length += PolygonWithHoles2d.getMessageSize(val);
    });
    return length + 76;
  }

  static datatype() {
    // Returns string type for a message object
    return 'convex_plane_decomposition_msgs/PlanarRegion';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '8cff8c52c8273f12e2fd17b9d4a3d417';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    geometry_msgs/Pose plane_parameters
    
    BoundingBox2d bbox2d
    
    PolygonWithHoles2d boundary
    
    PolygonWithHoles2d[] insets
    
    ================================================================================
    MSG: geometry_msgs/Pose
    # A representation of pose in free space, composed of position and orientation. 
    Point position
    Quaternion orientation
    
    ================================================================================
    MSG: geometry_msgs/Point
    # This contains the position of a point in free space
    float64 x
    float64 y
    float64 z
    
    ================================================================================
    MSG: geometry_msgs/Quaternion
    # This represents an orientation in free space in quaternion form.
    
    float64 x
    float64 y
    float64 z
    float64 w
    
    ================================================================================
    MSG: convex_plane_decomposition_msgs/BoundingBox2d
    # 3D, axis-aligned, bounding box
    float32 min_x
    float32 min_y
    float32 max_x
    float32 max_y
    ================================================================================
    MSG: convex_plane_decomposition_msgs/PolygonWithHoles2d
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
    const resolved = new PlanarRegion(null);
    if (msg.plane_parameters !== undefined) {
      resolved.plane_parameters = geometry_msgs.msg.Pose.Resolve(msg.plane_parameters)
    }
    else {
      resolved.plane_parameters = new geometry_msgs.msg.Pose()
    }

    if (msg.bbox2d !== undefined) {
      resolved.bbox2d = BoundingBox2d.Resolve(msg.bbox2d)
    }
    else {
      resolved.bbox2d = new BoundingBox2d()
    }

    if (msg.boundary !== undefined) {
      resolved.boundary = PolygonWithHoles2d.Resolve(msg.boundary)
    }
    else {
      resolved.boundary = new PolygonWithHoles2d()
    }

    if (msg.insets !== undefined) {
      resolved.insets = new Array(msg.insets.length);
      for (let i = 0; i < resolved.insets.length; ++i) {
        resolved.insets[i] = PolygonWithHoles2d.Resolve(msg.insets[i]);
      }
    }
    else {
      resolved.insets = []
    }

    return resolved;
    }
};

module.exports = PlanarRegion;
