(identifier) @variable

((identifier) @function.builtin
  (#any-of? @function.builtin
    "assert" "collectgarbage" "elapsedTime"
    "error" "gcinfo" "getfenv"
    "getmetatable" "ipairs" "loadstring"
    "next" "newproxy" "pairs"
    "pcall" "PluginManager" "print"
    "printidentity" "rawequal" "rawget"
    "rawlen" "rawset" "require"
    "select" "setfenv" "setmetatable"
    "spawn" "tick" "time"
    "tonumber" "tostring" "type"
    "typeof" "unpack" "UserSettings"
    "version" "warn"
    "xpcall")
)

((identifier) @variable.builtin
  (#any-of? @variable.builtin
    "_G" "_VERSION" "bit32"
    "coroutine" "debug"
    "game" "math" "os"
    "plugin" "script"
    "table" "task" "utf8"
    "workspace")
)

[
  (line_comment)
  (block_comment)
] @comment

[
  (quoted_string)
  (long_string)
  (interpolation_content)
] @string

[
  (unicode_escape)
  (decimal_escape)
  (hex_escape)
  (whitespace_escape)
  (simple_escape)
] @constant.character.escape

(number) @constant.numeric
(integer) @constant.numeric.integer
[
  (boolean)
  (boolean_type)
] @constant.builtin.boolean
[
  (nil)
  (nil_type)
] @constant.builtin
(vararg_expression) @constant

(attribute name: (identifier) @attribute)
(parameterized_attribute name: (identifier) @attribute)

[
  (break_statement)
  (continue_statement)
] @keyword.control

"return" @keyword.control.return

[
  "if"
  "elseif"
  "else"
  "then"
] @keyword.control.conditional

[
  "while"
  "repeat"
  "until"
  "for"
] @keyword.control.repeat

[
  "do"
  "end"
] @keyword

(function_body "end" @keyword.function)

"function" @keyword.function
"local" @keyword.storage.modifier

(type_alias_declaration "type" @keyword.storage.type)
(type_function_declaration "type" @keyword.storage.type)
(extern_type_declaration "type" @keyword.storage.type)

[
  "in"
  "and"
  "or"
  "not"
] @keyword.operator

(typeof_type "typeof" @keyword.operator)

(access_qualifier) @keyword.storage.modifier
(const_declaration "const" @keyword.storage.modifier)
(const_function_declaration "const" @keyword.storage.modifier)
(class_declaration "class" @keyword.storage.modifier)
(declare_global "declare" @keyword.storage.modifier)
(declare_function "declare" @keyword.storage.modifier)
(extern_type_declaration
  "declare" @keyword.storage.modifier
  "extern" @keyword.storage.modifier)
(class_property "public" @keyword.storage.modifier)
(class_method "public" @keyword.storage.modifier)
(class_declaration "extends" @keyword.storage.modifier)
(extern_type_declaration "extends" @keyword.storage.modifier)
(extern_type_declaration "with" @keyword.storage.modifier)
(local_declaration "export" @keyword.storage.modifier)
(const_declaration "export" @keyword.storage.modifier)
(function_declaration "export" @keyword.storage.modifier)
(class_declaration "export" @keyword.storage.modifier)
(type_alias_declaration "export" @keyword.storage.modifier)
(type_function_declaration "export" @keyword.storage.modifier)

[
  "+"
  "-"
  "*"
  "/"
  "//"
  "%"
  "^"
  "#"
  "=="
  "~="
  "<"
  "<="
  ">"
  ">="
  ".."
  "="
  "+="
  "-="
  "*="
  "/="
  "//="
  "%="
  "^="
  "..="
  "::"
  "->"
  "|"
  "&"
  "?"
] @operator

[
  ","
  ";"
  "."
  ":"
] @punctuation.delimiter

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
  "<"
  ">"
  "<<"
  ">>"
] @punctuation.bracket

(unicode_escape
  [
    "{"
    "}"
  ] @punctuation.special
  (escape_codepoint) @constant.numeric.integer)

(interpolated_string
  [
    "`"
    "{"
    "}"
  ] @punctuation.special)

(table_constructor
  [
    "{"
    "}"
  ] @constructor)

(binding name: (identifier) @variable)
((local_declaration
  bindings: (binding_list
    .
    (binding name: (identifier) @namespace)
    .)
  values: (expression_list
    .
    (method_call_expression
      receiver: (identifier) @variable.builtin
      method: (identifier) @function.builtin)
    .)
  (#eq? @variable.builtin "game")
  (#eq? @function.builtin "GetService")))
(const_declaration
  bindings: (binding_list
    (binding name: (identifier) @constant)))
(parameter name: (identifier) @variable.parameter)
(declare_parameter name: (identifier) @variable.parameter)
(function_type_parameter name: (identifier) @variable.parameter)

(function_declaration
  name: (function_name
    .
    name: (identifier) @function
    .))
(function_name field: (identifier) @function.method)
(function_name method: (identifier) @function.method)
(local_function_declaration name: (identifier) @function)
(const_function_declaration name: (identifier) @function)
(type_function_declaration name: (identifier) @type)
(declare_function name: (identifier) @function)
(extern_method name: (identifier) @function.method)
(class_method name: (identifier) @function.method)

(call_expression
  function: (identifier) @function
  .
  [
    (line_comment)
    (block_comment)
  ]*
  .
  arguments: (arguments) @_arguments
  (#not-eq? @_arguments ""))
(method_call_expression method: (identifier) @function.method)
(method_call_expression method: (identifier _ @function.method))
(type_instantiation_expression function: (identifier) @function)
(type_instantiation_expression method: (identifier) @function.method)

(field_expression field: (identifier) @variable.other.member)
(field_expression field: (identifier _ @variable.other.member))
(table_field key: (identifier) @variable.other.member)
(table_field key: (identifier _ @variable.other.member))
(table_field
  key: (identifier) @function.method
  value: (function_expression))
(call_expression
  function: (field_expression
    field: (identifier) @function)
  .
  [
    (line_comment)
    (block_comment)
  ]*
  .
  arguments: (arguments) @_arguments
  (#not-eq? @_arguments ""))
(type_instantiation_expression
  function: (field_expression
    field: (identifier) @function))
(property_type name: (identifier) @variable.other.member)
(extern_property name: (identifier) @variable.other.member)
(class_property name: (identifier) @variable.other.member)

(type_alias_declaration name: (identifier) @type)
(extern_type_declaration name: (identifier) @type)
(extern_type_declaration supertype: (identifier) @type)
(class_declaration name: (identifier) @type)
(class_reference module: (identifier) @namespace)
(class_reference name: (identifier) @type)
(type_reference module: (identifier) @namespace)
(type_reference name: (identifier) @type)

[
  (generic_type_definition name: (identifier))
  (generic_type_pack_definition name: (identifier))
  (generic_type name: (identifier))
  (generic_type_pack name: (identifier))
] @type.parameter

((type_reference name: (identifier) @type.builtin)
  (#any-of? @type.builtin
    "any" "boolean" "buffer" "never" "nil" "number" "string" "thread" "unknown" "userdata" "vector"))

; @generated by scripts/queries.nu; do not edit below.
; Source: Roblox/creator-docs 4c8f4030d48546d1e92a0c37f186cb91885e1ebf 2026-08-06
((type_reference name: (identifier) @type.builtin)
  (#any-of? @type.builtin
    "Accessory" "AccessoryDescription" "Accoutrement" "Actor" "AdGui"
    "AdPortal" "AdReward" "AdService" "AdvancedDragger" "AirController"
    "AlignOrientation" "AlignPosition" "AnalyticsService" "AngularVelocity" "Animation"
    "AnimationClip" "AnimationClipProvider" "AnimationConstraint" "AnimationController" "AnimationFromVideoCreatorService"
    "AnimationNodeDefinition" "AnimationRigData" "AnimationTrack" "Animator" "Annotation"
    "ArcHandles" "AssetDeliveryProxy" "AssetPatchSettings" "AssetService" "Atmosphere"
    "AtmosphereSensor" "Attachment" "AudioAnalyzer" "AudioChannelMixer" "AudioChannelSplitter"
    "AudioChorus" "AudioCompressor" "AudioDeviceInput" "AudioDeviceOutput" "AudioDistortion"
    "AudioEcho" "AudioEmitter" "AudioEqualizer" "AudioFader" "AudioFilter"
    "AudioFlanger" "AudioGate" "AudioLimiter" "AudioListener" "AudioPages"
    "AudioPitchShifter" "AudioPlayer" "AudioRecorder" "AudioReverb" "AudioSearchParams"
    "AudioSpeechToText" "AudioTextToSpeech" "AudioTremolo" "AvatarCreationService" "AvatarEditorService"
    "Axes" "Backpack" "BackpackItem" "BadgeService" "BallSocketConstraint"
    "BanHistoryPages" "BaseCoreGuiConfiguration" "BasePart" "BasePlayerGui" "BaseRemoteEvent"
    "BaseScript" "BaseWrap" "Beam" "BevelMesh" "BillboardGui"
    "BinaryStringValue" "BindableEvent" "BindableFunction" "BlockMesh" "BloomEffect"
    "BlurEffect" "BodyAngularVelocity" "BodyColors" "BodyForce" "BodyGyro"
    "BodyMover" "BodyPartDescription" "BodyPosition" "BodyThrust" "BodyVelocity"
    "Bone" "BoolValue" "BoxHandleAdornment" "BrickColor" "BrickColorValue"
    "BrowserService" "BubbleChatConfiguration" "BubbleChatMessageProperties" "BuoyancySensor" "CFrame"
    "CFrameValue" "CacheableContentProvider" "Camera" "CanvasGroup" "Capture"
    "CaptureService" "CapturesPages" "CapturesViewConfiguration" "CatalogPages" "CatalogSearchParams"
    "ChangeHistoryService" "ChannelTabsConfiguration" "CharacterAppearance" "CharacterMesh" "Chat"
    "ChatInputBarConfiguration" "ChatWindowConfiguration" "ChatWindowMessageProperties" "ChorusSoundEffect" "ClickDetector"
    "ClientReplicator" "ClimbController" "Clothing" "Clouds" "ClusterPacketCache"
    "Collection" "CollectionService" "Color3" "Color3Value" "ColorCorrectionEffect"
    "ColorGradingEffect" "ColorSequence" "ColorSequenceKeypoint" "CommerceService" "CompositeValueCurve"
    "CompressorSoundEffect" "ConeHandleAdornment" "ConfigService" "ConfigSnapshot" "Configuration"
    "ConfigureServerService" "Constraint" "Content" "ContentProvider" "ContextActionService"
    "Controller" "ControllerBase" "ControllerManager" "ControllerPartSensor" "ControllerSensor"
    "ControllerService" "CookiesService" "CoreGui" "CoreGuiConfiguration" "CornerWedgePart"
    "CreatorStoreService" "CurveAnimation" "CustomEvent" "CustomEventReceiver" "CustomLog"
    "CylinderHandleAdornment" "CylinderMesh" "CylindricalConstraint" "DataModel" "DataModelMesh"
    "DataModelSession" "DataStore" "DataStoreGetOptions" "DataStoreIncrementOptions" "DataStoreInfo"
    "DataStoreKey" "DataStoreKeyInfo" "DataStoreKeyPages" "DataStoreListingPages" "DataStoreObjectVersionInfo"
    "DataStoreOptions" "DataStorePages" "DataStoreService" "DataStoreSetOptions" "DataStoreVersionPages"
    "DateTime" "Debris" "DebugSettings" "Decal" "DepthOfFieldEffect"
    "Dialog" "DialogChoice" "DigitsRigDescription" "DistortionSoundEffect" "DockWidgetPluginGui"
    "DockWidgetPluginGuiInfo" "DoubleConstrainedValue" "DraftsService" "DragDetector" "Dragger"
    "DraggerService" "DynamicRotate" "EchoSoundEffect" "EditableImage" "EditableMesh"
    "EncodingService" "Enum" "EnumItem" "Enums" "EqualizerSoundEffect"
    "EulerRotationCurve" "ExperienceInviteOptions" "ExperienceNotificationService" "Explosion" "FaceControls"
    "FaceInstance" "Faces" "Feature" "FeatureRestrictionManager" "File"
    "FileMesh" "Fire" "Flag" "FlagStand" "FlagStandService"
    "FlangeSoundEffect" "FloatCurve" "FloatCurveKey" "FloorWire" "FluidForceSensor"
    "Folder" "Font" "ForceField" "FormFactorPart" "Frame"
    "FriendPages" "FriendService" "FunctionalTest" "GamePassService" "GameSettings"
    "GamepadService" "GeneratedFolder" "GenerationService" "GenericChallengeService" "GenericSettings"
    "Geometry" "GeometryService" "GetTextBoundsParams" "GlobalDataStore" "GlobalSettings"
    "Glue" "GroundController" "GroupService" "GuiBase" "GuiBase2d"
    "GuiBase3d" "GuiButton" "GuiLabel" "GuiMain" "GuiObject"
    "GuiService" "GuidRegistryService" "HSRDataContentProvider" "HandleAdornment" "Handles"
    "HandlesBase" "HapticEffect" "HapticService" "Hat" "HeapProfilerService"
    "HeightmapImporterService" "HiddenSurfaceRemovalAsset" "Highlight" "HingeConstraint" "Hint"
    "Hole" "Hopper" "HopperBin" "HttpRbxApiService" "HttpService"
    "Humanoid" "HumanoidController" "HumanoidDescription" "HumanoidRigDescription" "IKControl"
    "ILegacyStudioBridge" "ImageButton" "ImageHandleAdornment" "ImageLabel" "IncrementalPatchBuilder"
    "InputAction" "InputActionLabel" "InputBinding" "InputContext" "InputObject"
    "InsertService" "Instance" "InstanceAdornment" "InstanceFileSyncService" "IntConstrainedValue"
    "IntValue" "IntersectOperation" "InventoryPages" "JointInstance" "JointsService"
    "KeyboardService" "Keyframe" "KeyframeMarker" "KeyframeSequence" "KeyframeSequenceProvider"
    "LayerCollector" "Light" "Lighting" "LineForce" "LineHandleAdornment"
    "LinearVelocity" "LocalScript" "LocalizationService" "LocalizationTable" "LogService"
    "LoginService" "LuaSettings" "LuaSourceContainer" "LuaWebService" "MLService"
    "MLSession" "MakeupDescription" "ManualGlue" "ManualSurfaceJointInstance" "ManualWeld"
    "MarkerCurve" "MarketplaceService" "MatchmakingService" "MaterialService" "MaterialVariant"
    "MemStorageConnection" "MemStorageService" "MemoryStoreHashMap" "MemoryStoreHashMapPages" "MemoryStoreQueue"
    "MemoryStoreService" "MemoryStoreSortedMap" "MeshContentProvider" "MeshPart" "Message"
    "MessagingService" "MicroProfilerService" "Model" "ModerationService" "ModuleScript"
    "Motor" "Motor6D" "MotorFeature" "Mouse" "MouseService"
    "MultipleDocumentInterfaceInstance" "NegateOperation" "NetworkClient" "NetworkMarker" "NetworkPeer"
    "NetworkReplicator" "NetworkServer" "NetworkSettings" "NoCollisionConstraint" "NotificationService"
    "NumberPose" "NumberRange" "NumberSequence" "NumberSequenceKeypoint" "NumberValue"
    "Object" "ObjectValue" "OpenCloudApiV1" "OpenCloudService" "OrderedDataStore"
    "OutfitPages" "OverlapParams" "PVAdornment" "PVInstance" "PackageLink"
    "PackageService" "Pages" "Pants" "Part" "PartAdornment"
    "PartOperation" "PartOperationAsset" "ParticleEmitter" "PatchBundlerFileWatch" "PatchMapping"
    "Path" "Path2D" "Path2DControlPoint" "PathWaypoint" "PathfindingLink"
    "PathfindingModifier" "PathfindingService" "PermissionsService" "PhysicalProperties" "PhysicsService"
    "PhysicsSettings" "PitchShiftSoundEffect" "PlacesService" "Plane" "PlaneConstraint"
    "Platform" "Player" "PlayerGui" "PlayerListConfiguration" "PlayerMouse"
    "PlayerScripts" "PlayerViewService" "Players" "Plugin" "PluginAction"
    "PluginCapabilities" "PluginConnection" "PluginConnectionService" "PluginDebugService" "PluginDragEvent"
    "PluginGui" "PluginGuiService" "PluginManagementService" "PluginManager" "PluginManagerInterface"
    "PluginMenu" "PluginMouse" "PluginToolbar" "PluginToolbarButton" "PointLight"
    "PointsService" "PolicyService" "Pose" "PoseBase" "PostEffect"
    "PrismaticConstraint" "ProceduralModel" "ProcessInstancePhysicsService" "ProximityPrompt" "ProximityPromptService"
    "PublishService" "PyramidHandleAdornment" "RBXScriptConnection" "RBXScriptSignal" "Random"
    "Ray" "RayValue" "RaycastParams" "RaycastResult" "RecommendationPages"
    "RecommendationService" "Rect" "ReflectionMetadata" "ReflectionMetadataCallbacks" "ReflectionMetadataClass"
    "ReflectionMetadataClasses" "ReflectionMetadataEnum" "ReflectionMetadataEnumItem" "ReflectionMetadataEnums" "ReflectionMetadataEvents"
    "ReflectionMetadataFunctions" "ReflectionMetadataItem" "ReflectionMetadataMember" "ReflectionMetadataProperties" "ReflectionMetadataYieldFunctions"
    "ReflectionService" "Region3" "Region3int16" "RemoteCommandService" "RemoteDebuggerServer"
    "RemoteEvent" "RemoteFunction" "RenderSettings" "ReplicatedFirst" "ReplicatedStorage"
    "ReverbSoundEffect" "RigidConstraint" "RocketPropulsion" "RodConstraint" "RopeConstraint"
    "Rotate" "RotateP" "RotateV" "RotationCurve" "RotationCurveKey"
    "RunService" "RunningAverageItemDouble" "RunningAverageItemInt" "RunningAverageTimeIntervalItem" "SceneAnalysisService"
    "ScreenGui" "ScreenshotCapture" "ScreenshotHud" "Script" "ScriptBuilder"
    "ScriptContext" "ScriptDebuggerService" "ScriptDocument" "ScriptEditorService" "ScriptProfilerService"
    "ScriptService" "ScrollingFrame" "Seat" "Secret" "SecurityCapabilities"
    "Selection" "SelectionBox" "SelectionHighlightManager" "SelectionLasso" "SelectionPartLasso"
    "SelectionPointLasso" "SelectionSphere" "SelfViewConfiguration" "SensorBase" "SerializationService"
    "ServerReplicator" "ServerScriptService" "ServerStorage" "ServiceProvider" "SessionCheckService"
    "SharedTable" "SharedTableRegistry" "Shirt" "ShirtGraphic" "SkateboardController"
    "SkateboardPlatform" "Skin" "Sky" "SlidingBallConstraint" "SlimContentProvider"
    "Smoke" "SmoothVoxelsUpgraderService" "Snap" "SocialService" "SolidModelContentProvider"
    "Sound" "SoundEffect" "SoundGroup" "SoundService" "Sparkles"
    "SpawnLocation" "SpawnerService" "SpecialMesh" "SphereHandleAdornment" "SpotLight"
    "SpringConstraint" "StandalonePluginScripts" "StandardPages" "StarterCharacterScripts" "StarterGear"
    "StarterGui" "StarterPack" "StarterPlayer" "StarterPlayerScripts" "StartupMessageService"
    "Stats" "StatsItem" "Status" "StopWatchReporter" "StringValue"
    "Studio" "StudioCaptureService" "StudioDeviceSimulatorService" "StudioScreenshotCapture" "StudioService"
    "StudioTestService" "StudioTheme" "StyleBase" "StyleDerive" "StyleLink"
    "StyleQuery" "StyleRule" "StyleSheet" "SunRaysEffect" "SurfaceAppearance"
    "SurfaceGui" "SurfaceGuiBase" "SurfaceLight" "SurfaceSelection" "SwimController"
    "SyncScriptBuilder" "TaskScheduler" "Team" "TeamCreateData" "TeamCreateService"
    "Teams" "TeleportAsyncResult" "TeleportOptions" "TeleportService" "Terrain"
    "TerrainDetail" "TerrainRegion" "TestService" "TextBox" "TextBoxService"
    "TextButton" "TextChannel" "TextChannelWindow" "TextChatCommand" "TextChatConfigurations"
    "TextChatMessage" "TextChatMessageProperties" "TextChatService" "TextFilterResult" "TextFilterTranslatedResult"
    "TextGenerator" "TextLabel" "TextService" "TextSource" "Texture"
    "TimerService" "Tool" "Torque" "TorsionSpringConstraint" "TotalCountTimeIntervalItem"
    "TouchInputService" "TouchTransmitter" "Trail" "Translator" "TremoloSoundEffect"
    "TriangleMeshPart" "TrussPart" "Tween" "TweenBase" "TweenInfo"
    "TweenService" "UDim" "UDim2" "UIAspectRatioConstraint" "UIBase"
    "UIComponent" "UIConstraint" "UICorner" "UIDragDetector" "UIFlexItem"
    "UIGradient" "UIGridLayout" "UIGridStyleLayout" "UILayout" "UIListLayout"
    "UIPadding" "UIPageLayout" "UIScale" "UIShadow" "UISizeConstraint"
    "UIStroke" "UITableLayout" "UITextSizeConstraint" "UnionOperation" "UniqueIdLookupService"
    "UniversalConstraint" "UnreliableRemoteEvent" "User" "UserGameSettings" "UserInputService"
    "UserService" "UserSettings" "VRService" "ValueBase" "ValueCurve"
    "ValueCurveKey" "Vector2" "Vector2int16" "Vector3" "Vector3Curve"
    "Vector3Value" "Vector3int16" "VectorForce" "VehicleController" "VehicleSeat"
    "VelocityMotor" "VideoCapture" "VideoCaptureService" "VideoDisplay" "VideoFrame"
    "VideoPlayer" "VideoSampler" "VideoService" "ViewportFrame" "VirtualInput"
    "VirtualInputManager" "VirtualUser" "VisibilityCheckDispatcher" "Visit" "VoiceChatService"
    "WebStreamClient" "WedgePart" "Weld" "WeldConstraint" "Wire"
    "WireframeHandleAdornment" "Workspace" "WorkspaceAnnotation" "WorldModel" "WorldRoot"
    "WrapDeformer" "WrapLayer" "WrapTarget" "WrapTextureTransfer"
  ))

([
  (field_expression table: (identifier) @type.builtin)
  (method_call_expression receiver: (identifier) @type.builtin)
  (type_instantiation_expression receiver: (identifier) @type.builtin)
]
  (#any-of? @type.builtin
    "Axes" "BrickColor" "CFrame" "Color3" "ColorSequence"
    "ColorSequenceKeypoint" "Content" "DateTime" "DockWidgetPluginGuiInfo" "Enum"
    "Faces" "FloatCurveKey" "Font" "Instance" "NumberRange"
    "NumberSequence" "NumberSequenceKeypoint" "OverlapParams" "Path2DControlPoint" "PathWaypoint"
    "PhysicalProperties" "Random" "Ray" "RaycastParams" "Rect"
    "Region3" "Region3int16" "RotationCurveKey" "SecurityCapabilities" "SharedTable"
    "TweenInfo" "UDim" "UDim2" "User" "ValueCurveKey"
    "Vector2" "Vector2int16" "Vector3" "Vector3int16"
  )
)
; @end generated Roblox types

((call_expression function: (identifier) @function.builtin)
  (#any-of? @function.builtin
    "assert" "collectgarbage" "elapsedTime"
    "error" "gcinfo" "getfenv"
    "getmetatable" "ipairs" "loadstring"
    "next" "newproxy" "pairs"
    "pcall" "PluginManager" "print"
    "printidentity" "rawequal" "rawget"
    "rawlen" "rawset" "require"
    "select" "setfenv" "setmetatable"
    "spawn" "tick" "time"
    "tonumber" "tostring" "type"
    "typeof" "unpack" "UserSettings"
    "version" "warn"
    "xpcall")
)

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "bit32")
  (#any-of? @function.builtin
    "arshift" "lrotate" "lshift" "replace"
    "rrotate" "rshift" "btest" "bxor"
    "band" "bnot" "bor" "countlz"
    "countrz" "extract" "byteswap")
)

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "coroutine")
  (#any-of? @function.builtin
    "close" "create" "isyieldable"
    "resume" "running" "status"
    "wrap" "yield")
)

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "debug")
  (#any-of? @function.builtin
    "info" "traceback" "profilebegin"
    "profileend" "resetmemorycategory" "setmemorycategory"
    "dumpcodesize")
)

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "math")
  (#any-of? @function.builtin
    "abs" "acos" "asin"
    "atan" "atan2" "ceil"
    "clamp" "cos" "cosh"
    "deg" "exp" "floor"
    "fmod" "frexp" "isfinite"
    "isinf" "isnan" "ldexp"
    "log" "log10" "max"
    "min" "modf" "noise"
    "pow" "rad" "random"
    "randomseed" "round" "sign"
    "sin" "sinh" "sqrt"
    "tan" "tanh")
)

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @constant.builtin)
  (#eq? @variable.builtin "math")
  (#any-of? @constant.builtin "huge" "pi")
)

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "os")
  (#any-of? @function.builtin "clock" "date" "difftime" "time")
)

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "string")
  (#any-of? @function.builtin
    "byte" "char" "find"
    "format" "gmatch" "gsub"
    "len" "lower" "match"
    "pack" "packsize" "rep"
    "reverse" "split" "sub"
    "unpack" "upper")
)

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "table")
  (#any-of? @function.builtin
    "create" "clear" "clone"
    "concat" "foreach" "foreachi"
    "find" "freeze" "getn"
    "insert" "isfrozen" "maxn"
    "move" "pack" "remove"
    "sort" "unpack")
)

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "task")
  (#any-of? @function.builtin
    "cancel" "defer" "delay"
    "synchronize" "desynchronize" "spawn"
    "wait")
)

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "utf8")
  (#any-of? @function.builtin
    "char" "codepoint" "codes"
    "graphemes" "len" "offset"
    "nfcnormalize" "nfdnormalize")
)

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @constant.builtin)
  (#eq? @variable.builtin "utf8")
  (#eq? @constant.builtin "charpattern")
)

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "buffer")
  (#any-of? @function.builtin
    "create" "fromstring" "tostring"
    "len" "copy" "fill"
    "readi8" "readu8" "readi16"
    "readu16" "readi32" "readu32"
    "readf32" "readf64" "writei8"
    "writeu8" "writei16" "writeu16"
    "writei32" "writeu32" "writef32"
    "writef64" "readstring" "writestring")
)

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "vector")
  (#any-of? @function.builtin
    "create" "magnitude" "normalize"
    "cross" "dot" "angle"
    "floor" "ceil" "abs"
    "sign" "clamp" "max"
    "min")
)

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @constant.builtin)
  (#eq? @variable.builtin "vector")
  (#any-of? @constant.builtin "zero" "one")
)

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "types")
  (#any-of? @function.builtin
    "singleton" "negationof" "unionof"
    "intersectionof" "newtable" "newfunction"
    "copy" "generic" "optional")
)

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @constant.builtin)
  (#eq? @variable.builtin "types")
  (#any-of? @constant.builtin
    "any" "unknown" "never"
    "boolean" "buffer" "number"
    "string" "thread")
)

((field_expression
  table: (identifier) @type.builtin
  field: (identifier) @function.builtin)
  (#eq? @type.builtin "Content")
  (#any-of? @function.builtin "fromUri" "fromAssetId" "fromObject")
)

((field_expression
  table: (identifier) @type.builtin
  field: (identifier) @constant.builtin)
  (#eq? @type.builtin "Content")
  (#eq? @constant.builtin "none")
)

((method_call_expression
  receiver: (identifier) @variable.builtin
  method: (identifier) @function.builtin
  arguments: (arguments
    (expression_list
      .
      (string
        (quoted_string) @string.special))))
  (#eq? @variable.builtin "game")
  (#eq? @function.builtin "GetService")
)

((line_comment) @keyword.directive
  (#match? @keyword.directive "^--!(strict|nonstrict|nocheck|native|optimize [0-2])$"))

(ERROR) @error
