// Auto-generated. Do not edit!

// (in-package convex_plane_decomposition_msgs.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let PlanarRegion = require('./PlanarRegion.js');
let grid_map_msgs = _finder('grid_map_msgs');

//-----------------------------------------------------------

class PlanarTerrain {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.planarRegions = null;
      this.gridmap = null;
    }
    else {
      if (initObj.hasOwnProperty('planarRegions')) {
        this.planarRegions = initObj.planarRegions
      }
      else {
        this.planarRegions = [];
      }
      if (initObj.hasOwnProperty('gridmap')) {
        this.gridmap = initObj.gridmap
      }
      else {
        this.gridmap = new grid_map_msgs.msg.GridMap();
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type PlanarTerrain
    // Serialize message field [planarRegions]
    // Serialize the length for message field [planarRegions]
    bufferOffset = _serializer.uint32(obj.planarRegions.length, buffer, bufferOffset);
    obj.planarRegions.forEach((val) => {
      bufferOffset = PlanarRegion.serialize(val, buffer, bufferOffset);
    });
    // Serialize message field [gridmap]
    bufferOffset = grid_map_msgs.msg.GridMap.serialize(obj.gridmap, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type PlanarTerrain
    let len;
    let data = new PlanarTerrain(null);
    // Deserialize message field [planarRegions]
    // Deserialize array length for message field [planarRegions]
    len = _deserializer.uint32(buffer, bufferOffset);
    data.planarRegions = new Array(len);
    for (let i = 0; i < len; ++i) {
      data.planarRegions[i] = PlanarRegion.deserialize(buffer, bufferOffset)
    }
    // Deserialize message field [gridmap]
    data.gridmap = grid_map_msgs.msg.GridMap.deserialize(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    object.planarRegions.forEach((val) => {
      length += PlanarRegion.getMessageSize(val);
    });
    length += grid_map_msgs.msg.GridMap.getMessageSize(object.gridmap);
    return length + 4;
  }

  static datatype() {
    // Returns string type for a message object
    return 'convex_plane_decomposition_msgs/PlanarTerrain';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '081e702fce247ef5685dd96b39e3dfd4';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    PlanarRegion[] planarRegions
    grid_map_msgs/GridMap gridmap
    ================================================================================
    MSG: convex_plane_decomposition_msgs/PlanarRegion
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
    ================================================================================
    MSG: grid_map_msgs/GridMap
    # Grid map header
    GridMapInfo info
    
    # Grid map layer names.
    string[] layers
    
    # Grid map basic layer names (optional). The basic layers
    # determine which layers from `layers` need to be valid
    # in order for a cell of the grid map to be valid.
    string[] basic_layers
    
    # Grid map data.
    std_msgs/Float32MultiArray[] data
    
    # Row start index (default 0).
    uint16 outer_start_index
    
    # Column start index (default 0).
    uint16 inner_start_index
    
    ================================================================================
    MSG: grid_map_msgs/GridMapInfo
    # Header (time and frame)
    Header header
    
    # Resolution of the grid [m/cell].
    float64 resolution
    
    # Length in x-direction [m].
    float64 length_x
    
    # Length in y-direction [m].
    float64 length_y
    
    # Pose of the grid map center in the frame defined in `header` [m].
    geometry_msgs/Pose pose
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
    MSG: std_msgs/Float32MultiArray
    # Please look at the MultiArrayLayout message definition for
    # documentation on all multiarrays.
    
    MultiArrayLayout  layout        # specification of data layout
    float32[]         data          # array of data
    
    
    ================================================================================
    MSG: std_msgs/MultiArrayLayout
    # The multiarray declares a generic multi-dimensional array of a
    # particular data type.  Dimensions are ordered from outer most
    # to inner most.
    
    MultiArrayDimension[] dim # Array of dimension properties
    uint32 data_offset        # padding elements at front of data
    
    # Accessors should ALWAYS be written in terms of dimension stride
    # and specified outer-most dimension first.
    # 
    # multiarray(i,j,k) = data[data_offset + dim_stride[1]*i + dim_stride[2]*j + k]
    #
    # A standard, 3-channel 640x480 image with interleaved color channels
    # would be specified as:
    #
    # dim[0].label  = "height"
    # dim[0].size   = 480
    # dim[0].stride = 3*640*480 = 921600  (note dim[0] stride is just size of image)
    # dim[1].label  = "width"
    # dim[1].size   = 640
    # dim[1].stride = 3*640 = 1920
    # dim[2].label  = "channel"
    # dim[2].size   = 3
    # dim[2].stride = 3
    #
    # multiarray(i,j,k) refers to the ith row, jth column, and kth channel.
    
    ================================================================================
    MSG: std_msgs/MultiArrayDimension
    string label   # label of given dimension
    uint32 size    # size of given dimension (in type units)
    uint32 stride  # stride of given dimension
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new PlanarTerrain(null);
    if (msg.planarRegions !== undefined) {
      resolved.planarRegions = new Array(msg.planarRegions.length);
      for (let i = 0; i < resolved.planarRegions.length; ++i) {
        resolved.planarRegions[i] = PlanarRegion.Resolve(msg.planarRegions[i]);
      }
    }
    else {
      resolved.planarRegions = []
    }

    if (msg.gridmap !== undefined) {
      resolved.gridmap = grid_map_msgs.msg.GridMap.Resolve(msg.gridmap)
    }
    else {
      resolved.gridmap = new grid_map_msgs.msg.GridMap()
    }

    return resolved;
    }
};

module.exports = PlanarTerrain;
