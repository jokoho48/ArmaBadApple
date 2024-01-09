disableSerialization;

JK_frames = call compile loadFile "BadApple.sqf";

JK_width = JK_frames select 0 select 0;
JK_height = JK_frames select 0 select 1;

JK_frames = JK_frames select 1;

JK_FrameIndex = 0;

JK_markers = [];

for "_y" from 1 to JK_height do {
    for "_x" from 1 to JK_width do {
        private _pos = [_x, _y];
        _pos = _pos vectorMultiply [-1, -1];
        _pos = _pos vectorAdd [JK_width, JK_height];
        _pos = _pos vectorMultiply [10, 10];

        private _marker = createMarkerLocal [format["%1_%2", _x, _y], [_x, _y]];
        _marker setMarkerTypeLocal "mil_dot";
        _marker setMarkerColorLocal "ColorBlack";
        _marker setMarkerShadowLocal false;
        JK_markers pushBack _marker;
    };
};
reverse JK_markers;
JK_frames = JK_frames apply {
    if (_x isEqualType 0) then {
        _x
    } else {
        private _numberValues = (_x regexFind ["[0-9]+"]) apply {parseNumber (_x select 0 select 0)};
        private _values = (_x regexFind ["t|f"]) apply {["ColorBlack", "ColorWhite"] select (_x select 0 select 0 == "t")};
        [_numberValues, _values]
    };
};

private _map = ((findDisplay 12) displayCtrl 51);

_map ctrlAddEventHandler ["Draw", {
    private _ctrl = _this select 0;
    private _frameData = JK_frames select JK_FrameIndex;
    if (_frameData isEqualType 0) then {
        _frameData = JK_frames select _frameData;
    };

    private _xPos = 0;
    private _yPos = 0;
    private _numberValues = _frameData select 0;
    private _values = _frameData select 1;
    private _idx = 0;
    {
        for "_i" from 0 to _x - 1 do {
            (JK_markers select _idx) setMarkerColorLocal (_values select _forEachIndex);
            _idx = _idx + 1;
        };
    } forEach _numberValues;

    diag_log _idx;

    JK_FrameIndex = JK_FrameIndex + 1;
    if (JK_FrameIndex >= count JK_frames) then {
        JK_FrameIndex = 0;
    };
}];

addMissionEventHandler ["Map", {
    private _map = ((findDisplay 12) displayCtrl 51);
    _map ctrlMapAnimAdd [0, 0.16, [436.507,368.001]];
    ctrlMapAnimCommit _map;
    0 spawn {
        sleep 1;
        JK_FrameIndex = 0;
    };
}];