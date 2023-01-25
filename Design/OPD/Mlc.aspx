<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Mlc.aspx.cs" Inherits="Design_OPD_Mlc" MasterPageFile="~/DefaultHome.master" MaintainScrollPositionOnPostback="true" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        var onFileSelectSpaceFor = function (el) {
            var divCaptureImage = $('#divSpaceFor');
            var _flUpload = $('#divSpaceFor').find('#flUploadSpaceFor');
            _flUpload.click();
        }

        var previewBrowseImageSpaceFor = function (fileInput) {
            var files = fileInput.files;
            for (var i = 0; i < files.length; i++) {
                var file = files[i];
                var img = document.getElementById("imgPreviewSpaceFor");
                img.file = file;
                var reader = new FileReader();
                reader.onload = (function (aImg) {
                    return function (e) {
                        aImg.src = e.target.result;
                    };
                })(img);
                reader.readAsDataURL(file);
            }
        }

        var onFileSelectPrivateParty = function (el) {
            var divCaptureImage = $('#divPrivateParty');
            var _flUpload = $('#divPrivateParty').find('#flUploadPrivateParty');
            _flUpload.click();
        }

        var previewBrowseImagePrivateParty = function (fileInput) {
            var files = fileInput.files;
            for (var i = 0; i < files.length; i++) {
                var file = files[i];
                var img = document.getElementById("imgPreviewPrivateParty");
                img.file = file;
                var reader = new FileReader();
                reader.onload = (function (aImg) {
                    return function (e) {
                        aImg.src = e.target.result;
                    };
                })(img);
                reader.readAsDataURL(file);
            }
        }


        var onFileSelectMedicalOfficer = function (el) {
            var divCaptureImage = $('#divMedicalOfficer');
            var _flUpload = $('#divMedicalOfficer').find('#flUploadMedicalOfficer');
            _flUpload.click();
        }

        var previewBrowseImageMedicalOfficer = function (fileInput) {
            var files = fileInput.files;
            for (var i = 0; i < files.length; i++) {
                var file = files[i];
                var img = document.getElementById("imgPreviewMedicalOfficer");
                img.file = file;
                var reader = new FileReader();
                reader.onload = (function (aImg) {
                    return function (e) {
                        aImg.src = e.target.result;
                    };
                })(img);
                reader.readAsDataURL(file);
            }
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>For Medicolegal Cases </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
           </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTransactionId" runat="server" AutoCompleteType="Disabled" TabIndex="1" ToolTip="Enter IPD No." MaxLength="10"></asp:TextBox>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPatientName" runat="server" AutoCompleteType="Disabled"
                                TabIndex="2" ToolTip="Enter Patient Name"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPatientID" runat="server" AutoCompleteType="Disabled"
                                TabIndex="3" ToolTip="Enter Registration No."></asp:TextBox>
                        </div>
                    </div>


                </div>
            </div>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                 <input type="button" id="btnSearch"  value="Search" />
            </div>
        </div>


        <div class="POuter_Box_Inventory" id="dvSearchResult" style="display: none;">
            <div class="Purchaseheader">
                Details
            </div>
            <div id="dvPatientDetails" style="overflow: auto;">
            </div>
        </div>
        <div id="gdhide">
            <asp:Panel ID="pnlDetails" runat="server"  style="display:none;" >
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <div class="Purchaseheader">
                        Insert Details
                    </div>

                    <div class="row">

                        <div class="col-md-24">
                            <div class="row">
                                <div class="col-md-4">
                                    <label class="pull-left">Patient Name</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:Label ID="lblPatientName" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">UHID</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:Label ID="lblPatientID" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    <asp:Label ID="lblpid" runat="server" Style="display: none;" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    <asp:Label ID="lbltransactionId" runat="server" Style="display: none;" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                </div>

                            </div>


                            <div class="row">
                                <div class="col-md-4">
                                    <label class="pull-left">Address</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:Label ID="lblPaddress" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">Panel</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:Label ID="lblPanelComp" runat="server" CssClass="ItDoseLabelSp pull-left "></asp:Label>
                                </div>
                            </div>



                            <div class="row">
                                <div class="col-md-4">
                                    <label class="pull-left">S/O</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtS_O" MaxLength="200" AutoComplete="off" runat="server"></asp:TextBox>
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">Occupation</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtOccupation" MaxLength="200" TextMode="MultiLine" AutoComplete="off" runat="server"></asp:TextBox>
                                </div>

                            </div>
                            
                            <div class="row">
                                 <div class="col-md-4">
                                    <label class="pull-left">Caste</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtCaste" MaxLength="200" TextMode="MultiLine" AutoComplete="off" runat="server"></asp:TextBox>
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">Police Station</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtPoliceStation" MaxLength="200" AutoComplete="off" runat="server"></asp:TextBox>
                                </div>
                               

                            </div>

                            <div class="row">
                                <div class="col-md-4">
                                    <label class="pull-left">Residence </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtResidence" MaxLength="200" AutoComplete="off" runat="server"></asp:TextBox>
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">Friend / Relative Name</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtRelativeName" MaxLength="200" AutoComplete="off" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="row">

                                <div class="col-md-4">
                                    <label class="pull-left">Date & Time Of Exam.</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                   <%-- <asp:TextBox ID="txtExamnation_date" MaxLength="200" AutoComplete="off" runat="server"></asp:TextBox>--%>

                                    <asp:TextBox ID="txtExamnation_Date" runat="server" ToolTip="Click To Select Date" Width="295px" onchange="ChkDate();"
                                        TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                                    <cc1:CalendarExtender ID="ExamnationDate_CalendarExtender" runat="server" TargetControlID="txtExamnation_Date"
                                        Format="dd-MMM-yyyy" ClearTime="true">
                                    </cc1:CalendarExtender>
                                 
                            <asp:TextBox ID="txtExamnation_time" runat="server" MaxLength="8" Width="100px" ToolTip="Enter Time"
                                TabIndex="2" />
                                    <cc1:MaskedEditExtender ID="Examnation_time_masTime" Mask="99:99" runat="server" MaskType="Time"
                                        TargetControlID="txtExamnation_time" AcceptAMPM="true">
                                    </cc1:MaskedEditExtender>
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">Date & Hour Of Arrival </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <%--<asp:TextBox ID="txtArrivalHour" MaxLength="200" AutoComplete="off" runat="server"></asp:TextBox>--%>
                                    <asp:TextBox ID="txtArrivalHour_Date" runat="server" ToolTip="Click To Select Date" Width="295px" onchange="ChkDate();"
                                        TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                                    <cc1:CalendarExtender ID="txtArrivalHour_CalendarExtender" runat="server" TargetControlID="txtArrivalHour_Date"
                                        Format="dd-MMM-yyyy" ClearTime="true">
                                    </cc1:CalendarExtender>
                                   
                            <asp:TextBox ID="txtArrivalHour_time" runat="server" MaxLength="8" Width="100px" ToolTip="Enter Time"
                                TabIndex="2" />
                                    <cc1:MaskedEditExtender ID="txtArrivalHour_mskTime" Mask="99:99" runat="server" MaskType="Time"
                                        TargetControlID="txtArrivalHour_time" AcceptAMPM="true">
                                    </cc1:MaskedEditExtender>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-4">
                                    <label class="pull-left">No & Date Of Police Docket</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtPoliceDocket" MaxLength="200" AutoComplete="off" runat="server"></asp:TextBox>
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">No and name of Constable</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtNameOfConstable" MaxLength="200" AutoComplete="off" runat="server"></asp:TextBox>
                                </div>

                            </div>
                            <div class="row">
                                <div class="col-md-4">
                                    <label class="pull-left" title="Date & Hour of Report Sent to Police">D. & H. of Sent to Police</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <%-- <asp:TextBox ID="txtReport_sentToPoliceHour" MaxLength="200" AutoComplete="off" runat="server"></asp:TextBox>--%>

                                    <asp:TextBox ID="txtReport_sentToPolice_Date" runat="server" ToolTip="Click To Select Date" Width="295px" onchange="ChkDate();"
                                        TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                                    <cc1:CalendarExtender ID="Report_sentToPoliceDate_CalendarExtender" runat="server" TargetControlID="txtReport_sentToPolice_Date"
                                        Format="dd-MMM-yyyy" ClearTime="true">
                                    </cc1:CalendarExtender>
                                
                            <asp:TextBox ID="txtReport_sentToPolice_Time" runat="server" MaxLength="8" Width="100px" ToolTip="Enter Time"
                                TabIndex="2" />
                                    <cc1:MaskedEditExtender ID="Report_sentToPoliceTime_masTime" Mask="99:99" runat="server" MaskType="Time"
                                        TargetControlID="txtReport_sentToPolice_Time" AcceptAMPM="true">
                                    </cc1:MaskedEditExtender>

                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">Name Of Injuries</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <input type="radio" name="NameOfInjuries" value="Simple" checked="checked" />
                                    Simple 
                                    <input type="radio" name="NameOfInjuries" value="Grieves or Dangerous" />
                                    Grieves or Dangerous 
                                </div>
                            </div>
                            <div class="row">

                                <div class="col-md-4">
                                    <label class="pull-left">Portable duration of Injuries </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtPortable_Duration_Of_Injuries" MaxLength="200" AutoComplete="off" runat="server"></asp:TextBox>
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left" title="The Kind Of Weapons used or poison">The Kind Of Weapons used or poison</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txt_Weapons_Used_Or_Poison" MaxLength="200" AutoComplete="off" runat="server"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-4">
                                    <label class="pull-left" title="Suspected In Case Of Poisoning ">Suspect In Case Of Poison.</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtCase_Of_Poisoning" MaxLength="200" AutoComplete="off" runat="server"></asp:TextBox>
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">Identification Marks 1 </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txt_Identification_Marks_1" MaxLength="200" AutoComplete="off" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="row">

                                <div class="col-md-4">
                                    <label class="pull-left">Identification Marks 2</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txt_Identification_Marks_2" MaxLength="200" AutoComplete="off" runat="server"></asp:TextBox>
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">Identification Marks 3</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txt_Identification_Marks_3" MaxLength="200" AutoComplete="off" runat="server"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-24">
                                    <label class="pull-left">Particulars Of Injuries,Symptoms,In Case Of Poisioning :</label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-24">
                                    <CKEditor:CKEditorControl ID="txtDetail" BasePath="~/ckeditor" runat="server" EnterMode="BR"></CKEditor:CKEditorControl>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-2">
                                </div>

                                <div class="col-md-6" id="divSpaceFor">
                                    <button class="save" type="button" onclick="onFileSelectSpaceFor(this)">Browse Thumb Impression</button>
                                    <input type="file" id="flUploadSpaceFor" accept="image/x-png,image/jpeg,image/jpg" style="display: none" class="hidden" onchange="previewBrowseImageSpaceFor(this)" />
                                </div>
                                <div class="col-md-6" id="divPrivateParty">
                                    <button class="save" type="button" onclick="onFileSelectPrivateParty(this)">Browse Private Party Signature </button>
                                    <input type="file" id="flUploadPrivateParty" accept="image/x-png,image/jpeg,image/jpg" style="display: none" class="hidden" onchange="previewBrowseImagePrivateParty(this)" />

                                </div>
                                <div class="col-md-6" id="divMedicalOfficer">
                                    <button class="save" type="button" onclick="onFileSelectMedicalOfficer(this)">Browse Medical Officer Signature  </button>
                                    <input type="file" id="flUploadMedicalOfficer" accept="image/x-png,image/jpeg,image/jpg" style="display: none" class="hidden" onchange="previewBrowseImageMedicalOfficer(this)" />
                                </div>
                                <div class="col-md-2">
                                </div>

                            </div>
                            <div class="row">
                                <div class="col-md-2">
                                </div>
                                <div class="col-md-6">
                                    <img style="width: 70%; height: 70%;" id="imgPreviewSpaceFor" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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" alt="Preview" />
                                </div>

                                <div class="col-md-6">
                                    <img style="width: 70%; height: 70%;" id="imgPreviewPrivateParty" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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" alt="Preview" />
                                </div>

                                <div class="col-md-6">
                                    <img style="width: 70%; height: 70%;" id="imgPreviewMedicalOfficer" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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" alt="Preview" />
                                </div>
                                <div class="col-md-2">
                                </div>
                            </div>
                            <div class="row">
                            </div>
                        </div>


                    </div>
                </div>
                <div id="divSave" class="POuter_Box_Inventory" style="text-align: center;">
                    <input type="button" style="width: 100px; margin-top: 7px" id="btnSave" runat="server" class="ItDoseButton" value="Save" onclick="save(this)" />
                </div>
            </asp:Panel>
        </div>
       

        <div class="POuter_Box_Inventory" id="dvPatientHistory" style="display: none;">
            <div class="Purchaseheader">
                Patient History
            </div>
            <div id="dvPatientHistoryDetail" style="overflow: auto;">
            </div>

        </div>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            $('#<%=txtPatientID.ClientID%>').focus();
         
            $("#btnSearch").click(function () { getPatientDetails(); getPatientHistory(); clearAll(); });
           
        });


        function getPatientDetails() {
            $("#dvSearchResult,#dvPatientDetails").hide();
            $("#btnSearch").val("Searching...").attr("disabled", true);
            serverCall('mlc.aspx/getPatientDetails', { PatientId: $.trim($('#<%=txtPatientID.ClientID%>').val()), PatientName: $.trim($('#<%=txtPatientName.ClientID%>').val()), IPNO: $.trim($('#<%=txtTransactionId.ClientID%>').val()) }, function (response) {
                responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    var htmlOutPut = $("#scrptPatientDetails").parseTemplate(responseData);
                    $("#dvPatientDetails").html(htmlOutPut);
                    $("#btnSearch").val("Search").attr("disabled", false);
                    $("#dvSearchResult,#dvPatientDetails").show();
                }
                else {
                    modelAlert('No Record Found', function () { });
                    $("#btnSearch").val("Search").attr("disabled", false);
                }
            });


        }

        function getPatientHistory() {

            $("#dvPatientHistory,#dvPatientHistoryDetail").hide();
            $("#btnSearchHistory").val("Searching...").attr("disabled", true);
            serverCall('mlc.aspx/getPatientHistory', { PatientId: $.trim($('#<%=txtPatientID.ClientID%>').val()), PatientName: $.trim($('#<%=txtPatientName.ClientID%>').val()), IPNO: $.trim($('#<%=txtTransactionId.ClientID%>').val()) }, function (response) {
                responseData2 = JSON.parse(response);
                if (responseData2.length > 0) {
                    var htmlOutPut = $("#scriptPatientHistory").parseTemplate(responseData2);
                    $("#dvPatientHistoryDetail").html(htmlOutPut);
                    $("#btnSearchHistory").val("Search").attr("disabled", false);
                    $("#dvPatientHistory,#dvPatientHistoryDetail").show();
                }
                else {
                    modelAlert('No Record Found', function () { });
                    $("#btnSearchHistory").val("Search").attr("disabled", false);
                }
            });

        }




        var getDetails = function (callback) {
            var data = {
                pid: $.trim($('#<%=lblpid.ClientID%>').text()),
                patientID: $.trim($('#<%=lblPatientID.ClientID%>').text()),
                transactionId: $.trim($('#<%=lbltransactionId.ClientID%>').text()),
                S_O: $.trim($('#<%=txtS_O.ClientID%>').val()),
                Occupation: $.trim($('#<%=txtOccupation.ClientID%>').val()),
                Caste: $.trim($('#<%=txtCaste.ClientID%>').val()),
                PoliceStation: $.trim($('#<%=txtPoliceStation.ClientID%>').val()),
                Residence: $.trim($('#<%=txtResidence.ClientID%>').val()),
                RelativeName: $.trim($('#<%=txtRelativeName.ClientID%>').val()),
               
                PoliceDocket: $.trim($('#<%=txtPoliceDocket.ClientID%>').val()),
                NameOfConstable: $.trim($('#<%=txtNameOfConstable.ClientID%>').val()),
               
                NameOfInjuries: $.trim($('input[name="NameOfInjuries"]:checked').val()),
                Portable_Duration_Of_Injuries: $.trim($('#<%=txtPortable_Duration_Of_Injuries.ClientID%>').val()),
                Weapons_Used_Or_Poison: $.trim($('#<%=txt_Weapons_Used_Or_Poison.ClientID%>').val()),
                Case_Of_Poisoning: $.trim($('#<%=txtCase_Of_Poisoning.ClientID%>').val()),
                Identification_Marks_1: $.trim($('#<%=txt_Identification_Marks_1.ClientID%>').val()),
                Identification_Marks_2: $.trim($('#<%=txt_Identification_Marks_2.ClientID%>').val()),
                Identification_Marks_3: $.trim($('#<%=txt_Identification_Marks_3.ClientID%>').val()),
                imgSpaceFor: $('#imgPreviewSpaceFor').prop('src'),
                imgPrivateParty: $('#imgPreviewPrivateParty').prop('src'),
                imgMedicalOfficer: $('#imgPreviewMedicalOfficer').prop('src'),
                Particulars: $.trim(CKEDITOR.instances['<%=txtDetail.ClientID%>'].getData()),
                Examnation_Date: $.trim($('#<%=txtExamnation_Date.ClientID%>').val()),
                Examnation_time: $.trim($('#<%=txtExamnation_time.ClientID%>').val()),
                ArrivalHour_Date: $.trim($('#<%=txtArrivalHour_Date.ClientID%>').val()),
                ArrivalHour_time: $.trim($('#<%=txtArrivalHour_time.ClientID%>').val()),
                Report_sentToPolice_Date: $.trim($('#<%=txtReport_sentToPolice_Date.ClientID%>').val()),
                Report_sentToPolice_Time: $.trim($('#<%=txtReport_sentToPolice_Time.ClientID%>').val()),
               
            }
            callback(data);
        }

        var getVarificationDetails = function (callback) {
            getDetails(function (data) {
                callback(data);
            });
        }


        var save = function (btnSave) {
            getVarificationDetails(function (data) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('Mlc.aspx/Save', data, function (response) {
                    var $responseData = JSON.parse(response);
                    modelAlert($responseData.response, function () {
                        if ($responseData.status) {
                            clearAll();
                            getPatientHistory();
                        }
                        else
                            $(btnSave).removeAttr('disabled').val('Save');
                    });
                });
            });
        }


        function clearAll() {


            var base64Image = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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";


            $('#<%=lblpid.ClientID%>').text('');
            $('#<%=lblPatientID.ClientID%>').text('');
            $('#<%=lbltransactionId.ClientID%>').text('');
            $('#<%=lblPatientName.ClientID%>').text('');
            $('#<%=lblPaddress.ClientID%>').text('');
            $('#<%=lblPanelComp.ClientID%>').text('');

           
            $('#<%=txtCaste.ClientID%>').val('');
            $('#<%=txtPoliceStation.ClientID%>').val('');
            $('#<%=txtS_O.ClientID%>').val('');
            $('#<%=txtOccupation.ClientID%>').val('');
            $('#<%=txtResidence.ClientID%>').val('');
            $('#<%=txtRelativeName.ClientID%>').val('');
           
           
            $('#<%=txtPoliceDocket.ClientID%>').val('');
            $('#<%=txtNameOfConstable.ClientID%>').val('');
    
         
            $('#<%=txtPortable_Duration_Of_Injuries.ClientID%>').val('');
            $('#<%=txt_Weapons_Used_Or_Poison.ClientID%>').val('');
            $('#<%=txtCase_Of_Poisoning.ClientID%>').val('');
            $('#<%=txt_Identification_Marks_1.ClientID%>').val('');
            $('#<%=txt_Identification_Marks_2.ClientID%>').val('');
            $('#<%=txt_Identification_Marks_3.ClientID%>').val('');



            $('#imgPreviewSpaceFor').prop('src', base64Image);
            $('#imgPreviewPrivateParty').prop('src', base64Image);
            $('#imgPreviewMedicalOfficer').prop('src', base64Image);
            CKEDITOR.instances['<%=txtDetail.ClientID%>'].setData('')







            $('#<%=btnSave.ClientID%>').removeAttr('disabled').val('Save');
            $('#<%=pnlDetails.ClientID%>').hide();

        }




        function viewPatientDetail(img) {
            var row = $(img).closest("tr");
            var data = JSON.parse($(row).find("#tdData").text());
            $('#<%=lblPatientID.ClientID%>').text(data.PatientId);
            $('#<%=lbltransactionId.ClientID%>').text(data.TransactionID);
            $('#<%=lblPatientName.ClientID%>').text(data.Pname);
            $('#<%=lblPaddress.ClientID%>').text(data.Address);
            $('#<%=lblPanelComp.ClientID%>').text(data.PanelName);
            $('#<%=pnlDetails.ClientID%>').show();

        }


        function viewPatientHistory(img) {
            var row = $(img).closest("tr");
            var data = JSON.parse($(row).find("#tdData2").text());
            $('#<%=lblpid.ClientID%>').text(data.ofpbid);
            $('#<%=lblPatientID.ClientID%>').text(data.PatientID);
            $('#<%=lbltransactionId.ClientID%>').text(data.TransactionId);
            $('#<%=lblPatientName.ClientID%>').text(data.pname);
            $('#<%=lblPaddress.ClientID%>').text(data.Address);
            $('#<%=lblPanelComp.ClientID%>').text(data.PanelName);

           
            $('#<%=txtS_O.ClientID%>').val(data.S_O);
            $('#<%=txtOccupation.ClientID%>').val(data.Occupation);

            $('#<%=txtCaste.ClientID%>').val(data.Caste);
            $('#<%=txtPoliceStation.ClientID%>').val(data.PoliceStation);
            $('#<%=txtResidence.ClientID%>').val(data.Residence);
            $('#<%=txtRelativeName.ClientID%>').val(data.RelativeName);
            
            
            $('#<%=txtPoliceDocket.ClientID%>').val(data.PoliceDocket);
            $('#<%=txtNameOfConstable.ClientID%>').val(data.NameOfConstable);
          

      

            $("input[name=NameOfInjuries][value=" + data.NameOfInjuries + "]").prop('checked', true);

            $('#<%=txtPortable_Duration_Of_Injuries.ClientID%>').val(data.Portable_Duration_Of_Injuries);
            $('#<%=txt_Weapons_Used_Or_Poison.ClientID%>').val(data.Weapons_Used_Or_Poison);
            $('#<%=txtCase_Of_Poisoning.ClientID%>').val(data.Case_Of_Poisoning);
            $('#<%=txt_Identification_Marks_1.ClientID%>').val(data.Identification_Marks_1);
            $('#<%=txt_Identification_Marks_2.ClientID%>').val(data.Identification_Marks_2);
            $('#<%=txt_Identification_Marks_3.ClientID%>').val(data.Identification_Marks_3);
           
             

            $('#imgPreviewSpaceFor').prop('src', data.imgSpaceForBase64);
            $('#imgPreviewPrivateParty').prop('src', data.imgPrivatePartyBase64);
            $('#imgPreviewMedicalOfficer').prop('src', data.imgMedicalOfficerBase64);
            CKEDITOR.instances['<%=txtDetail.ClientID%>'].setData(data.Particulars)

            if (data.ofpbid != '') {
                $('#<%=btnSave.ClientID%>').removeAttr('disabled').val('Update');
            }

            $('#<%=pnlDetails.ClientID%>').show();

            
        }

        function cancelRecord(img) {
            var row = $(img).closest("tr");
            var data = JSON.parse($(row).find("#tdData2").text());
            modelConfirmation('Confirmation !', 'Do you want to delete ?', 'Delete', 'Cancel', function (status) {
                if (status) {
                    serverCall('mlc.aspx/cancelRecord', { pid: data.ofpbid, patientID: data.PatientID }, function (response) {
                        var $responseData = JSON.parse(response);
                        modelAlert($responseData.response, function () {
                            if ($responseData.status) {
                                getPatientHistory();
                            }

                        });
                    });
                }

            });

        }

        function printRecord(img) {
            var row = $(img).closest("tr");
            var data = JSON.parse($(row).find("#tdData2").text());
            modelConfirmation('Confirmation !', 'Do you want to print ?', 'Yes', 'No', function (status) {
                if (status) {
                    serverCall('mlc.aspx/printCard', { pid: data.ofpbid }, function (response) {
                        var $responseData = JSON.parse(response);
                      
                            if ($responseData.status) {
                                
                                window.open($responseData.Output);
                            }
                       
                    });
                }

            });

        }

    </script>

    <style type="text/css">
        #divPaymentControlParent {
            border: none;
        }
    </style>
    


    <script type="text/html" id="scriptPatientHistory">
        <table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;width:100%" >
		    <tr id="Tr1"> 
                       
                <th class="GridViewHeaderStyle" scope="col" style="width:30px;">#</th>                
                <th class="GridViewHeaderStyle" scope="col" >UHID</th>
                <th class="GridViewHeaderStyle" scope="col" >IP NO</th>
                <th class="GridViewHeaderStyle" scope="col" >Name</th>
                <th class="GridViewHeaderStyle" scope="col" >Address</th>
                <th class="GridViewHeaderStyle" scope="col" >S/O</th>
                <th class="GridViewHeaderStyle" scope="col" >Occupation</th>
                <th class="GridViewHeaderStyle" scope="col" >Residence</th>
                <th class="GridViewHeaderStyle" scope="col" >Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Edit</th>  
                <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Cancel</th>     
                <th class="GridViewHeaderStyle" scope="col" style="width:20px;"></th>     
             </tr>
            <#       
		    var dataLength=responseData2.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow; 
            var strStyle="";            
		    for(var j=0;j<dataLength;j++)
		    {       
		        objRow = responseData2[j];
               
                      
		    #>
            <tr id="Tr2" class="<#=strStyle#>">                
               
                <td class="GridViewLabItemStyle" style="width:20px;text-align:center;" ><#=(j+1)#></td>                                      
                <td class="GridViewLabItemStyle" id="td15" style="text-align:left;"><#=objRow.PatientID#></td>    
                <td class="GridViewLabItemStyle" id="td3" style="text-align:left;"><#=objRow.ipno#></td>    
				<td class="GridViewLabItemStyle" id="td4" style="text-align:left;"><#=objRow.pname#></td> 
                <td class="GridViewLabItemStyle" id="td5" style="text-align:center;"><#=objRow.Address#></td>
                <td class="GridViewLabItemStyle" id="td6" style="text-align:center;"><#=objRow.S_O #></td>
                <td class="GridViewLabItemStyle" id="td12" style="text-align:center;"><#=objRow.Occupation #></td>
                <td class="GridViewLabItemStyle" id="td7" style="text-align:center;"><#=objRow.Residence #></td>
                
                <td class="GridViewLabItemStyle" id="td14" style="text-align:center;"><#=objRow.EntryDate#></td>
                <td class="GridViewLabItemStyle tdData" id="tdData2" style="display:none"><#=JSON.stringify(objRow) #></td> 
                         <td class="GridViewLabItemStyle" id="td9" style="width:50px;text-align:center;">
                        <img id="img1" src="../../Images/edit.png" style="cursor:pointer;" title="Click To Edit" onclick="viewPatientHistory(this);"/>
                </td>      
                 <td class="GridViewLabItemStyle" id="td10" style="width:30px;text-align:center;">
                    <#if(objRow.ofpbid!=''){#>
                        <img id="img2" src="../../Images/Delete.gif" style="cursor:pointer;" title="Click To Cancel " onclick="cancelRecord(this);"/>
                    <#}#>
                </td> 
                      <td class="GridViewLabItemStyle" id="td13" style="width:30px;text-align:center;">
                    <#if(objRow.ofpbid!=''){#>
                        <img id="img3" src="../../Images/print.gif" style="cursor:pointer;" title="Click To Print " onclick="printRecord(this);"/>
                    <#}#>
                </td>          
            </tr>              
		    <#}        
		    #>                    
        </table>
    </script>
    <script type="text/html" id="scrptPatientDetails">
        <table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;width:100%" >
		    <tr id="tdHeader"> 
                       
                <th class="GridViewHeaderStyle" scope="col" style="width:30px;">#</th>                
                <th class="GridViewHeaderStyle" scope="col" >UHID</th>
                <th class="GridViewHeaderStyle" scope="col" >IPNo</th>
                <th class="GridViewHeaderStyle" scope="col" >Name</th>
                <th class="GridViewHeaderStyle" scope="col" >Gender</th>
                <th class="GridViewHeaderStyle" scope="col" >Panel</th>
                <th class="GridViewHeaderStyle" scope="col" >Address</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;"></th>      
             </tr>
            <#       
		    var dataLength=responseData.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow; 
            var strStyle="";  
               
		    for(var j=0;j<dataLength;j++)
		    {       
		        objRow = responseData[j];
               
                      
		    #>
            <tr id="tdRow_<#=(j+1)#>" class="<#=strStyle#>">                
               
                <td class="GridViewLabItemStyle" style="width:20px;text-align:center;" ><#=(j+1)#></td>                                      
                <td class="GridViewLabItemStyle" id="td8" style="text-align:left;"><#=objRow.PatientId#></td>    
                <td class="GridViewLabItemStyle" id="tdPatientID" style="text-align:left;"><#=objRow.TransNo#></td>    
				<td class="GridViewLabItemStyle" id="tdPName" style="text-align:left;"><#=objRow.Pname#></td>
                <td class="GridViewLabItemStyle" id="td11" style="text-align:left;"><#=objRow.gender#></td>  
                <td class="GridViewLabItemStyle" id="td2" style="text-align:left;"><#=objRow.PanelName#></td>  
                <td class="GridViewLabItemStyle" id="td1" style="text-align:center;"><#=objRow.Address#></td>

                <td class="GridViewLabItemStyle tdData" id="tdData" style="display:none"><#=JSON.stringify(objRow) #></td> 
                         <td class="GridViewLabItemStyle" id="tdUpdate" style="width:50px;text-align:center;">
                        <img id="imgViewRecord" src="../../Images/Post.gif" style="cursor:pointer;" title="Click To View" onclick="viewPatientDetail(this);"/>
                </td>              
            </tr>              
		    <#}  
                #>  
		              
        </table>
    </script>
</asp:Content>
