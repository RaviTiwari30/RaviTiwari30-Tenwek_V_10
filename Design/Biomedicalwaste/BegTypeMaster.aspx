<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="BegTypeMaster.aspx.cs" Inherits="Design_Biomedicalwaste_BegTypeMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        var colors = {
            "aliceblue": "#f0f8ff",
            "antiquewhite": "#faebd7",
            "aqua": "#00ffff",
            "aquamarine": "#7fffd4",
            "azure": "#f0ffff",
            "beige": "#f5f5dc",
            "bisque": "#ffe4c4",
            "black": "#000000",
            "blanchedalmond": "#ffebcd",
            "blue": "#0000ff",
            "blueviolet": "#8a2be2",
            "brown": "#a52a2a",
            "burlywood": "#deb887",
            "cadetblue": "#5f9ea0",
            "chartreuse": "#7fff00",
            "chocolate": "#d2691e",
            "coral": "#ff7f50",
            "cornflowerblue": "#6495ed",
            "cornsilk": "#fff8dc",
            "crimson": "#dc143c",
            "cyan": "#00ffff",
            "darkblue": "#00008b",
            "darkcyan": "#008b8b",
            "darkgoldenrod": "#b8860b",
            "darkgray": "#a9a9a9",
            "darkgreen": "#006400",
            "darkgrey": "#a9a9a9",
            "darkkhaki": "#bdb76b",
            "darkmagenta": "#8b008b",
            "darkolivegreen": "#556b2f",
            "darkorange": "#ff8c00",
            "darkorchid": "#9932cc",
            "darkred": "#8b0000",
            "darksalmon": "#e9967a",
            "darkseagreen": "#8fbc8f",
            "darkslateblue": "#483d8b",
            "darkslategray": "#2f4f4f",
            "darkslategrey": "#2f4f4f",
            "darkturquoise": "#00ced1",
            "darkviolet": "#9400d3",
            "deeppink": "#ff1493",
            "deepskyblue": "#00bfff",
            "dimgray": "#696969",
            "dimgrey": "#696969",
            "dodgerblue": "#1e90ff",
            "firebrick": "#b22222",
            "floralwhite": "#fffaf0",
            "forestgreen": "#228b22",
            "fuchsia": "#ff00ff",
            "gainsboro": "#dcdcdc",
            "ghostwhite": "#f8f8ff",
            "gold": "#ffd700",
            "goldenrod": "#daa520",
            "gray": "#808080",
            "green": "#008000",
            "greenyellow": "#adff2f",
            "grey": "#808080",
            "honeydew": "#f0fff0",
            "hotpink": "#ff69b4",
            "indianred": "#cd5c5c",
            "indigo": "#4b0082",
            "ivory": "#fffff0",
            "khaki": "#f0e68c",
            "lavender": "#e6e6fa",
            "lavenderblush": "#fff0f5",
            "lawngreen": "#7cfc00",
            "lemonchiffon": "#fffacd",
            "lightblue": "#add8e6",
            "lightcoral": "#f08080",
            "lightcyan": "#e0ffff",
            "lightgoldenrodyellow": "#fafad2",
            "lightgray": "#d3d3d3",
            "lightgreen": "#90ee90",
            "lightgrey": "#d3d3d3",
            "lightpink": "#ffb6c1",
            "lightsalmon": "#ffa07a",
            "lightseagreen": "#20b2aa",
            "lightskyblue": "#87cefa",
            "lightslategray": "#778899",
            "lightslategrey": "#778899",
            "lightsteelblue": "#b0c4de",
            "lightyellow": "#ffffe0",
            "lime": "#00ff00",
            "limegreen": "#32cd32",
            "linen": "#faf0e6",
            "magenta": "#ff00ff",
            "maroon": "#800000",
            "mediumaquamarine": "#66cdaa",
            "mediumblue": "#0000cd",
            "mediumorchid": "#ba55d3",
            "mediumpurple": "#9370db",
            "mediumseagreen": "#3cb371",
            "mediumslateblue": "#7b68ee",
            "mediumspringgreen": "#00fa9a",
            "mediumturquoise": "#48d1cc",
            "mediumvioletred": "#c71585",
            "midnightblue": "#191970",
            "mintcream": "#f5fffa",
            "mistyrose": "#ffe4e1",
            "moccasin": "#ffe4b5",
            "navajowhite": "#ffdead",
            "navy": "#000080",
            "oldlace": "#fdf5e6",
            "olive": "#808000",
            "olivedrab": "#6b8e23",
            "orange": "#ffa500",
            "orangered": "#ff4500",
            "orchid": "#da70d6",
            "palegoldenrod": "#eee8aa",
            "palegreen": "#98fb98",
            "paleturquoise": "#afeeee",
            "palevioletred": "#db7093",
            "papayawhip": "#ffefd5",
            "peachpuff": "#ffdab9",
            "peru": "#cd853f",
            "pink": "#ffc0cb",
            "plum": "#dda0dd",
            "powderblue": "#b0e0e6",
            "purple": "#800080",
            "rebeccapurple": "#663399",
            "red": "#ff0000",
            "rosybrown": "#bc8f8f",
            "royalblue": "#4169e1",
            "saddlebrown": "#8b4513",
            "salmon": "#fa8072",
            "sandybrown": "#f4a460",
            "seagreen": "#2e8b57",
            "seashell": "#fff5ee",
            "sienna": "#a0522d",
            "silver": "#c0c0c0",
            "skyblue": "#87ceeb",
            "slateblue": "#6a5acd",
            "slategray": "#708090",
            "slategrey": "#708090",
            "snow": "#fffafa",
            "springgreen": "#00ff7f",
            "steelblue": "#4682b4",
            "tan": "#d2b48c",
            "teal": "#008080",
            "thistle": "#d8bfd8",
            "tomato": "#ff6347",
            "turquoise": "#40e0d0",
            "violet": "#ee82ee",
            "wheat": "#f5deb3",
            "white": "#ffffff",
            "whitesmoke": "#f5f5f5",
            "yellow": "#ffff00",
            "yellowgreen": "#9acd32"
        }
        $(document).ready(function () {
            bindbagTypeMaster(function () { });
            bindColors();
            $('#ddlColors').chosen();
            $('.hidden').hide();
            //$('#txtDrugCategoryName').focus();
        });

        var bindColors = function () {
            ddlColors = $('#ddlColors');
            Object.keys(colors).forEach(function (e, i) {
                ddlColors.append($(new Option).val(colors[e]).text(e).css('background-color', colors[e]));
            });
        }

        var onColorPreviewChange = function (v) {
            $('#divPreviewColor').css('background-color', v);
        }
        var Flag = 0;
        var ValidateData = function () {
            debugger;
            var Bagname = $('[id$=txtbagname]').val().trim();
            var BagColor = $('[id$=ddlColors]').val();
            var Description = $('[id$=txtdescription]').val().trim();
            var FileName = $('[id$=fileuploadmenu]').val();
            var UserID = '<%=Util.GetString(Session["ID"])%>';
            var IsActive = $('input[type=radio][name=rdoactive]:checked').val();
            var Savetype = $('[id$=btnsave]').val();
            var FileName1 = $('[id$=hdnBagImage]').val();

            var BagId = $('#spnBagID').text();
            if (Bagname == '') {
                modelAlert('Please Enter Bag Name', function () {
                    $('#txtbagname').focus();
                });
                return false;
            }
            if (BagColor == "0") {
                modelAlert('Please Select Group', function () {
                    $('#ddlColors').focus();
                });
                return false;
            }

            if (Description == '') {
                modelAlert('Please Enter Description', function () {
                    $('#txtdescription').focus();
                });
                return false;
            }
            if (Savetype == "Update") {
                if (BagId != "") {
                    if (FileName == "") {
                        //if (Flag == 0) {
                        modelConfirmation('Are you sure ?', 'Do You Update Bag With Out Image', 'Yes', 'No', function (status) {
                            debugger;
                            if (status == true) {
                                Flag++;
                                UpdateBagImage();
                                //SaveBagImageByHandler();
                            }
                            else {
                                return false;
                            }

                        });
                        //}
                        //else {
                        //    SaveBagImageByHandler();
                        //}


                    }
                    else {
                        SaveBagImageByHandler();
                    }
                }
            }
            else {

                if (FileName == '') {
                    modelAlert('Please Select Image', function () {
                        $('#fileuploadmenu').focus();
                    });
                    return false;
                }
                SaveBagImageByHandler();
            }
        }

        function UpdateBagImage() {
            debugger;
            var data = {
                Bagname: $('[id$=txtbagname]').val(),
                BagColor: $('[id$=ddlColors]').val(),
                Description: $('[id$=txtdescription]').val(),
                FileName: $('[id$=fileuploadmenu]').val(),

                UserID: '<%=Util.GetString(Session["ID"])%>',
                IsActive: $('input[type=radio][name=rdoactive]:checked').val(),
                Savetype: $('[id$=btnsave]').val(),
                BagId: $('#spnBagID').text(),
                Image: $('[id$=fileuploadmenu]').val().substring($('[id$=fileuploadmenu]').val().lastIndexOf("\\") + 1, $('[id$=fileuploadmenu]').val().length),

            }
            serverCall('Services/BioMedicalwaste.asmx/UpdateBagMasterType', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    bindbagTypeMaster(function () { });
                });
            });
        }
        function SaveBagImageByHandler() {
            debugger;
            var Bagname = $('[id$=txtbagname]').val();
            var BagColor = $('[id$=ddlColors]').val();
            var Description = $('[id$=txtdescription]').val();
            var FileName1 = $('[id$=fileuploadmenu]').val();
            var UserID = '<%=Util.GetString(Session["ID"])%>';
            var IsActive = $('input[type=radio][name=rdoactive]:checked').val();
            var Savetype = $('[id$=btnsave]').val();
            var BagId = $('#spnBagID').text();
            var FileName = $('[id$=hdnBagImage]').val();
            var fileupload = $('[id$=fileuploadmenu]').get(0);
            var files = fileupload.files;
            var Data = new FormData();
            for (var i = 0; i < files.length; i++) {
                Data.append(files[i].name, files[i]);
            }


            Data.append('Bagname', Bagname);
            Data.append('BagColor', BagColor);

            Data.append('UserID', UserID);
            Data.append('Description', Description);
            Data.append('IsActive', IsActive);
            Data.append('Savetype', Savetype);
            Data.append('BagId', BagId);
            if (files.length > 0) {
                $.ajax({
                    url: 'Services/SaveImage.ashx',
                    type: 'POST',
                    data: Data,
                    cache: false,
                    contentType: false,
                    processData: false,
                    success: function (result) {
                        debugger;
                        //modelAlert('Record Save Successfully!...', function () {
                        //    bindbagTypeMaster(function () { });
                        //});
                        if (result.Result == 1) {

                            modelAlert('Record Save Successfully!...', function () {
                                bindbagTypeMaster(function () { });
                            });
                        }

                        else if (result.Result == 2) {
                            modelAlert('Record Update Successfully!...', function () {
                                bindbagTypeMaster(function () { });
                            });
                        }
                        else {
                            modelAlert('Bag Already Exists!...', function () {
                                bindbagTypeMaster(function () { });
                            });
                        }
                    },
                    error: function (err) { alert(err.statusText); }
                });
            }
        }
        function bindbagTypeMaster() {
            serverCall('Services/BioMedicalwaste.asmx/bindBagTypeMasterDetails', { data: '' }, function (response) {
                var responseData = JSON.parse(response);
                bindBagDetails(responseData);
                Clear();
            });
        }
        function bindBagDetails(data) {
            debugger;
            $('#tbBagTypeList tbody').empty();
            var row = '';
            for (var i = 0; i < data.length; i++) {
                var j = $('#tbBagTypeList tbody tr').length + 1;
                row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdBagame" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BagName + '</td>';
                row += '<td id="tdBagColour" class="GridViewLabItemStyle" style="text-align: center;background-color:' + data[i].BagColour + '"><input type="hidden" id="hdnColorCode"  value=' + data[i].BagColour + '></td>';
                row += '<td id="tdBagDesc" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Description + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Active + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CreatedBy + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DateTime + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/edit.png" onclick="EditBagType(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdActive" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].IsActive + '</td>';
                row += '<td id="tdAID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ID + '</td>';
                row += '<td id="tdImage" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].Image + '</td>';

                row += '</tr>';
                $('#tbBagTypeList tbody').append(row);
            }
        }
        var Clear = function () {
            $('[id$=txtbagname]').val('');
            $('#divPreviewColor').css('background-color', '');
            $('[id$=txtdescription]').val('');
            $('[id$=fileuploadmenu]').val('');
            $('.hidden').hide();
            $('#rdoactive').prop('checked', true);
            $('[id$=btnsave]').val('Save');
            $('[id$=ddlColors]').val(0).chosen("destroy").chosen()


        }

        var EditBagType = function (rowID) {
            var row = $(rowID).closest('tr');
            $('#txtbagname').val(row.find('#tdBagame').text());
            $('#spnBagID').text(row.find('#tdAID').text());
            $("#ddlColors").val(row.find('#hdnColorCode').val()).trigger("chosen:updated");
            $('#txtdescription').val(row.find('#tdBagDesc').text());
            $("#hdnBagImage").val(row.find('#tdImage').text());
            $('.hidden').show();

            $('#divPreviewColor').css('background-color', row.find('#hdnColorCode').val());
            if (row.find('#tdActive').text() == "0") {
                $('input[type=radio][name=rdoactive][value=1]').prop('checked', false);
                $('input[type=radio][name=rdoactive][value=0]').prop('checked', true);
            }
            else {
                $('input[type=radio][name=rdoactive][value=0]').prop('checked', false);
                $('input[type=radio][name=rdoactive][value=1]').prop('checked', true);
            }
            $('[id$=btnsave]').val('Update');

        }
        SearchbyfirstName = function (elem) {
            var name = $.trim($(elem).val());
            var length = $.trim($(elem).val()).length;
            $('#tbBagTypeList tr').hide();
            $('#tbBagTypeList tr:first').show();
            $('#tbBagTypeList tr').find('td:eq(1)').filter(function () {

                if ($(this).text().substring(0, length).toLowerCase() == name.toLowerCase())
                    return $(this);
            }).parent('tr').show();;
        }
        var showdoimage = function () {
            debugger
            var data = {
                BagId: $('#spnBagID').text(),
            }
            serverCall('Services/BioMedicalwaste.asmx/GetBagImageForPopUp', data, function (response) {
                debugger;
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    var Image = responseData[0].Image;
                    $("#imgview").attr("src", Image);
                    //var Path = responseData[0].url.trim();
                    $('#divShowImage').showModel();

                }
                else {
                    modelAlert('No Record Found...', function () {

                    });
                }
            });
        }
    </script>
    <div id="Pbody_box_inventory">
        <asp:HiddenField ID="hdnBagImage" runat="server" ClientIDMode="Static" Value="" />
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Bag Type Master</b>
            <span style="display: none" id="spnBagID"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Enter Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">


                        <div class="col-md-3">
                            <label class="pull-left">Bag Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" autocomplete="off" id="txtbagname" class="requiredField" maxlength="200" placeholder="Enter Bag Name here" />
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">Bag Colour</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select onchange="onColorPreviewChange(this.value);" id="ddlColors">
                                <option value="0">Select Bag Colour</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Color Preview </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <div id="divPreviewColor" style="width: 100%; height: 100%; margin-top: 2px;">&nbsp;</div>
                        </div>
                    </div>
                    <div class="row">

                        <div class="col-md-3">
                            <label class="pull-left">Image</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:FileUpload ID="fileuploadmenu" runat="server" Width="200px" onchange="encodeImageFileAsURL(this)" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Description</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <textarea id="txtdescription" class="requiredField" style="height: 56px; text-transform: uppercase; margin: 0px; width: 228px; max-width: 228px; max-height: 90px;" placeholder="Enter Description here"></textarea>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">Is Active</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="radio" name="rdoactive" value="1" checked="checked" />Yes
                            <input type="radio" name="rdoactive" value="0" />No
                        </div>

                    </div>
                    <div class="row hidden">
                        <div class="col-md-3">
                            <label class="pull-left">View Image</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <a onclick="showdoimage()">
                                <asp:Image ID="imgView" runat="server" ImageUrl="../../Images/view.GIF" />
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <input type="button" id="btnsave" value="Save" onclick="return ValidateData();" />

                <input type="button" id="btnClear" value="Clear" onclick="Clear()" />

            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Accessories Details
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Search Bag Type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtsearch" onkeyup="SearchbyfirstName(this)" placeholder="Search by first name" />
                </div>
            </div>
            <div class="row">
                <div id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tbBagTypeList" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Bag Name</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Bag Colour</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Description</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Is Active Status</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Created By</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Created Date</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Edit</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div id="divShowImage" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 500px; height: 520px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divShowImage" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">View Bag</h4>

                </div>

                <div class="modal-body">
                    <div class="row">
                        <div style="text-align: center;">
                            <img id="imgview" style="width: 100%; height: 400px;" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">

                    <button type="button" data-dismiss="divShowImage">Close</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

