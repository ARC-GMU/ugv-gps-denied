// Auto-generated. Do not edit!

// (in-package elevation_map_msgs.srv)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let geometry_msgs = _finder('geometry_msgs');

//-----------------------------------------------------------


//-----------------------------------------------------------

class CheckSafetyRequest {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.polygons = null;
      this.compute_untraversable_polygon = null;
    }
    else {
      if (initObj.hasOwnProperty('polygons')) {
        this.polygons = initObj.polygons
      }
      else {
        this.polygons = [];
      }
      if (initObj.hasOwnProperty('compute_untraversable_polygon')) {
        this.compute_untraversable_polygon = initObj.compute_untraversable_polygon
      }
      else {
        this.compute_untraversable_polygon = false;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type CheckSafetyRequest
    // Serialize message field [polygons]
    // Serialize the length for message field [polygons]
    bufferOffset = _serializer.uint32(obj.polygons.length, buffer, bufferOffset);
    obj.polygons.forEach((val) => {
      bufferOffset = geometry_msgs.msg.PolygonStamped.serialize(val, buffer, bufferOffset);
    });
    // Serialize message field [compute_untraversable_polygon]
    bufferOffset = _serializer.bool(obj.compute_untraversable_polygon, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type CheckSafetyRequest
    let len;
    let data = new CheckSafetyRequest(null);
    // Deserialize message field [polygons]
    // Deserialize array length for message field [polygons]
    len = _deserializer.uint32(buffer, bufferOffset);
    data.polygons = new Array(len);
    for (let i = 0; i < len; ++i) {
      data.polygons[i] = geometry_msgs.msg.PolygonStamped.deserialize(buffer, bufferOffset)
    }
    // Deserialize message field [compute_untraversable_polygon]
    data.compute_untraversable_polygon = _deserializer.bool(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    object.polygons.forEach((val) => {
      length += geometry_msgs.msg.PolygonStamped.getMessageSize(val);
    });
    return length + 5;
  }

  static datatype() {
    // Returns string type for a service object
    return 'elevation_map_msgs/CheckSafetyRequest';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '7259452fd835a6852d543d6eec938e47';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    # Polygons to check
    geometry_msgs/PolygonStamped[] polygons
    bool compute_untraversable_polygon
    
    # Results
    
    ================================================================================
    MSG: geometry_msgs/PolygonStamped
    # This represents a Polygon with reference coordinate frame and timestamp
    Header header
    Polygon polygon
    
    ================================================================================
    MSG: std_msgs/Header
    # Standard metadata for higher-level stamped data types.
    # This is generally used to communicate timestamped data 
    # in a particular coordinate frame.
    # 
    # sequence ID: consecutively increasing ID 
    uint32 seq
    #Two-integer timestamp that is expressed as:
    # * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
    # * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
    # time-handling sugar is provided by the client library
    time stamp
    #Frame this data is associated with
    string frame_id
    
    ================================================================================
    MSG: geometry_msgs/Polygon
    #A specification of a polygon where the first and last points are assumed to be connected
    Point32[] points
    
    ================================================================================
    MSG: geometry_msgs/Point32
    # This contains the position of a point in free space(with 32 bits of precision).
    # It is recommeded to use Point wherever possible instead of Point32.  
    # 
    # This recommendation is to promote interoperability.  
    #
    # This message is designed to take up less space when sending
    # lots of points at once, as in the case of a PointCloud.  
    
    float32 x
    float32 y
    float32 z
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new CheckSafetyRequest(null);
    if (msg.polygons !== undefined) {
      resolved.polygons = new Array(msg.polygons.length);
      for (let i = 0; i < resolved.polygons.length; ++i) {
        resolved.polygons[i] = geometry_msgs.msg.PolygonStamped.Resolve(msg.polygons[i]);
      }
    }
    else {
      resolved.polygons = []
    }

    if (msg.compute_untraversable_polygon !== undefined) {
      resolved.compute_untraversable_polygon = msg.compute_untraversable_polygon;
    }
    else {
      resolved.compute_untraversable_polygon = false
    }

    return resolved;
    }
};

class CheckSafetyResponse {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.is_safe = null;
      this.traversability = null;
      this.untraversable_polygons = null;
    }
    else {
      if (initObj.hasOwnProperty('is_safe')) {
        this.is_safe = initObj.is_safe
      }
      else {
        this.is_safe = [];
      }
      if (initObj.hasOwnProperty('traversability')) {
        this.traversability = initObj.traversability
      }
      else {
        this.traversability = [];
      }
      if (initObj.hasOwnProperty('untraversable_polygons')) {
        this.untraversable_polygons = initObj.untraversable_polygons
      }
      else {
        this.untraversable_polygons = [];
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type CheckSafetyResponse
    // Serialize message field [is_safe]
    bufferOffset = _arraySerializer.bool(obj.is_safe, buffer, bufferOffset, null);
    // Serialize message field [traversability]
    bufferOffset = _arraySerializer.float64(obj.traversability, buffer, bufferOffset, null);
    // Serialize message field [untraversable_polygons]
    // Serialize the length for message field [untraversable_polygons]
    bufferOffset = _serializer.uint32(obj.untraversable_polygons.length, buffer, bufferOffset);
    obj.untraversable_polygons.forEach((val) => {
      bufferOffset = geometry_msgs.msg.PolygonStamped.serialize(val, buffer, bufferOffset);
    });
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type CheckSafetyResponse
    let len;
    let data = new CheckSafetyResponse(null);
    // Deserialize message field [is_safe]
    data.is_safe = _arrayDeserializer.bool(buffer, bufferOffset, null)
    // Deserialize message field [traversability]
    data.traversability = _arrayDeserializer.float64(buffer, bufferOffset, null)
    // Deserialize message field [untraversable_polygons]
    // Deserialize array length for message field [untraversable_polygons]
    len = _deserializer.uint32(buffer, bufferOffset);
    data.untraversable_polygons = new Array(len);
    for (let i = 0; i < len; ++i) {
      data.untraversable_polygons[i] = geometry_msgs.msg.PolygonStamped.deserialize(buffer, bufferOffset)
    }
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += object.is_safe.length;
    length += 8 * object.traversability.length;
    object.untraversable_polygons.forEach((val) => {
      length += geometry_msgs.msg.PolygonStamped.getMessageSize(val);
    });
    return length + 12;
  }

  static datatype() {
    // Returns string type for a service object
    return 'elevation_map_msgs/CheckSafetyResponse';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'beb1ac95aeeddf0ee9cd130e4e05c9d0';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    bool[] is_safe
    
    # Estimate of the traversability of the path.
    # Ranges from 0 to 1 where 0 means not traversable and 1 highly traversable.
    float64[] traversability
    
    # Polygons that are untraversable.
    geometry_msgs/PolygonStamped[] untraversable_polygons
    
    
    ================================================================================
    MSG: geometry_msgs/PolygonStamped
    # This represents a Polygon with reference coordinate frame and timestamp
    Header header
    Polygon polygon
    
    ================================================================================
    MSG: std_msgs/Header
    # Standard metadata for higher-level stamped data types.
    # This is generally used to communicate timestamped data 
    # in a particular coordinate frame.
    # 
    # sequence ID: consecutively increasing ID 
    uint32 seq
    #Two-integer timestamp that is expressed as:
    # * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
    # * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
    # time-handling sugar is provided by the client library
    time stamp
    #Frame this data is associated with
    string frame_id
    
    ================================================================================
    MSG: geometry_msgs/Polygon
    #A specification of a polygon where the first and last points are assumed to be connected
    Point32[] points
    
    ================================================================================
    MSG: geometry_msgs/Point32
    # This contains the position of a point in free space(with 32 bits of precision).
    # It is recommeded to use Point wherever possible instead of Point32.  
    # 
    # This recommendation is to promote interoperability.  
    #
    # This message is designed to take up less space when sending
    # lots of points at once, as in the case of a PointCloud.  
    
    float32 x
    float32 y
    float32 z
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new CheckSafetyResponse(null);
    if (msg.is_safe !== undefined) {
      resolved.is_safe = msg.is_safe;
    }
    else {
      resolved.is_safe = []
    }

    if (msg.traversability !== undefined) {
      resolved.traversability = msg.traversability;
    }
    else {
      resolved.traversability = []
    }

    if (msg.untraversable_polygons !== undefined) {
      resolved.untraversable_polygons = new Array(msg.untraversable_polygons.length);
      for (let i = 0; i < resolved.untraversable_polygons.length; ++i) {
        resolved.untraversable_polygons[i] = geometry_msgs.msg.PolygonStamped.Resolve(msg.untraversable_polygons[i]);
      }
    }
    else {
      resolved.untraversable_polygons = []
    }

    return resolved;
    }
};

module.exports = {
  Request: CheckSafetyRequest,
  Response: CheckSafetyResponse,
  md5sum() { return '137df6a3ff37546adfad4f1d40e233b4'; },
  datatype() { return 'elevation_map_msgs/CheckSafety'; }
};
