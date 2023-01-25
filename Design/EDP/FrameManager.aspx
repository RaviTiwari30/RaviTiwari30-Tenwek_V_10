<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="FrameManager.aspx.cs" Inherits="Design_EDP_FrameManager" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript">
        var popup
        function showDirectory() {
            var w = 350;
            var h = 455;
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            popup = window.open("browseDirectory.aspx?Frame=Frame", "view", "width=" + w + ",height=" + h + ",top=" + top + ",left=" + left + " ");
            popup.focus();
            return false
        }
        </script>
    <script type="text/javascript">
        $(document).ready(function () {
            var MaxLength = 100;
            $('#txtDescription').bind("keypress", function (e) {
                if (window.event) {
                    keynum = e.keyCode
                }
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }
                if ($(this).val().length >= MaxLength) {
                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                    {
                        e.preventDefault();
                        return false;
                    }
                }
            });
        });
        function SaveFrame() {
            if ($.trim($('#txtFileName').val()) == "") {
                $('#lblMsg').text('Please Enter File Name');
                $('#txtFileName').focus();
                return false;
            }
            if ($.trim($('#txtURL').val()) == "") {
                $('#lblMsg').text('Please Enter URL');
                $('#txtURL').focus();
                return false;
            }



            $("#lblMsg").text('');
            $('#btnSave').attr('disabled', 'disabled').val("Submiting...");

            var data = new Array();
            var obj = new Object();
            obj.FrameName = $("#ddlFrame option:selected").text();
            obj.FrameID = $("#ddlFrame").val();
            obj.FileName = encodeURIComponent($("#txtFileName").val());
            obj.URL = $("#txtURL").val();
            obj.Description = $("#txtDescription").val();
            obj.MenuHeader = $("#ddlMenuHeader").val();

            data.push(obj);
            if (data.length > 0) {
                $.ajax({
                    url: "Services/Frame.asmx/SaveFrame",
                    data: JSON.stringify({ Data: data }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        if (result.d == "1") {
                            $("#lblMsg").text('Record Saved Successfully');
                            $("#ddlFrame").prop('selectedIndex', 0);
                            $("#txtFileName").val('');
                            $("#txtURL").val('');
                            $("#txtDescription").val('');
                        }
                        else if (result.d == "2") {
                            $("#lblMsg").text('Already Page Exists');
                        }
                        else {
                            $("#lblMsg").text('Error occurred, Please contact administrator');
                        }
                        $('#btnSave').attr('disabled', false).val("Save");
                      
                    },
                    error: function (xhr, status) {
                        $("#lblMsg").text('Record Not Saved');
                        $('#btnSave').attr('disabled', false).val("Save");
                        
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
        }


        function showFrame() {
            $find('mpeCreateFrame').show();
        }

        function showHeaderFrame() {
            $find('mpeCreateFrameHeader').show();
        }


        function SaveFrameMaster() {
            if ($.trim($("#txtNFrame").val()) == "") {
                $("#lblFrame").text('Please Enter Frame Name');
                $("#txtNFrame").focus();
                return false;
            }
            if ($.trim($("#txtNFrame").val()) != "") {
                $.ajax({
                    url: "Services/Frame.asmx/SaveFrameMaster",
                    data: '{ FrameName: "' + $.trim($("#txtNFrame").val()) + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        if (result.d == "1") {
                            $("#lblMsg").text('Record Saved Successfully');
                            $("#txtNFrame").val('');
                        }
                        else if (result.d == "2") {
                            $("#lblMsg").text('Frame Already Exists');
                            $("#txtNFrame").val('');
                        }
                        else {
                            $("#lblMsg").text('Error occurred, Please contact administrator');
                        }
                        $find('mpeCreateFrame').hide();
                        bindFrame();
                    },
                    error: function (xhr, status) {
                        $("#lblMsg").text('Record Not Saved');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
        }


        function SaveFrameMasterMenuHeader() {
            if ($.trim($("#txtHeaderName").val()) == "") {
                $("#lblHeaderNameError").text('Please Enter Menu Header  Name');
                $("#txtNFrame").focus();
                return false;
            }
            if ($.trim($("#txtHeaderName").val()) != "") {
                $.ajax({
                    url: "Services/Frame.asmx/SaveFrameMasterMenuHeader",
                    data: '{ HName: "' + $.trim($("#txtHeaderName").val()) + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        if (result.d == "1") {
                            $("#lblMsg").text('Record Saved Successfully');
                            $("#txtNFrame").val('');
                        }
                        else if (result.d == "2") {
                            $("#lblMsg").text('Menu Header Already Exists');
                            $("#txtNFrame").val('');
                        }
                        else {
                            $("#lblMsg").text('Error occurred, Please contact administrator');
                        }
                        $find('mpeCreateFrameHeader').hide();
                        bindMenuHeader();
                    },
                    error: function (xhr, status) {
                        $("#lblMsg").text('Record Not Saved');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
        }


        function bindFrame() {
            var ddlFrame = $("#ddlFrame");
            $("#ddlFrame option").remove();
            $.ajax({
                url: "Services/Frame.asmx/BindFrameMaster",
                data: '{ }', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    FrameData = jQuery.parseJSON(result.d);
                    if (FrameData.length == 0) {
                        ddlFrame.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < FrameData.length; i++) {
                            ddlFrame.append($("<option></option>").val(FrameData[i].FrameID).html(FrameData[i].FrameName));
                        }
                    }
                },
                error: function (xhr, status) {
                    $("#lblMsg").text('Record Not Saved');
                    window.status = status + "\r\n" + xhr.responseText;

                }
            });
        }



        function bindMenuHeader() {
            var ddlMenuHeader = $("#ddlMenuHeader");
            $("#ddlMenuHeader option").remove();
            $.ajax({
                url: "Services/Frame.asmx/BindMenuHeader",
                data: '{ }', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    FrameData = jQuery.parseJSON(result.d);
                    if (FrameData.length == 0) {
                        ddlMenuHeader.append($("<option></option>").val("").html("---No Data Found---"));
                    }
                    else {
                        ddlMenuHeader.append($("<option></option>").val("").html("Select"));
                        for (i = 0; i < FrameData.length; i++) {
                            ddlMenuHeader.append($("<option></option>").val(FrameData[i].HeaderName).html(FrameData[i].HeaderName));
                        }
                    }
                },
                error: function (xhr, status) {
                    $("#lblMsg").text('Record Not Saved');
                    window.status = status + "\r\n" + xhr.responseText;

                }
            });
        }


        function ClearHeaderPopup() {
            $("#txtMenuHeaderName").val('');
           
        }
        function ClearPopup() {
            $("#txtNFrame").val('');
            $("#lblFrame").text('');
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpeCreateFrame")) {
                    $find("mpeCreateFrame").hide();
                    ClearPopup();
                    ClearHeaderPopup();
                }
            }
        }
        $(document).ready(function () {
            bindFrame();
            bindMenuHeader();
        });
    </script>
    <div id="Pbody_box_inventory">
        <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Frame Management</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Frame
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlFrame" ClientIDMode="Static" runat="server">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-5">
                            <input type="button" id="btnFrame" value="New" class="ItDoseButton" onclick="showFrame()" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                File&nbsp;Name 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox CssClass="requiredField" ID="txtFileName"  AutoCompleteType="Disabled" Width="95%" ClientIDMode="Static" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                URL
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-10">
                            <asp:TextBox ID="txtURL" runat="server" AutoCompleteType="Disabled" Font-Bold="true" MaxLength="70" CssClass="requiredField"
                                Width="226px" ClientIDMode="Static"></asp:TextBox>
                            <a href="javascript:void(0);" onclick="showDirectory();">
                                <img src="../../Images/view.GIF" style="border: none;" alt="" /></a>
                            <asp:Label ID="lblFile" runat="server" CssClass="ItDoseLabelSp" Text="(URL&nbsp; : ../IPD/FileName.aspx)"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Description
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDescription" ClientIDMode="Static" Width="95%" runat="server"
                                TextMode="MultiLine"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Menu Header
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlMenuHeader" runat="server" ClientIDMode="Static">
                                
                            </asp:DropDownList>
                        </div>
                            <div class="col-md-5">
                            <input type="button" id="btnHeader" value="New" class="ItDoseButton" onclick="showHeaderFrame()" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory textCenter" >
            <input type="button" value="Save" id="btnSave" onclick="SaveFrame()" class="save margin-top-on-btn" />
        </div>
    </div>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton" />
    </div>
    <cc1:ModalPopupExtender ID="mpeCreateFrame" runat="server" CancelControlID="btnRCancel"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlFrame" PopupDragHandleControlID="dragHandle" BehaviorID="mpeCreateFrame" OnCancelScript="ClearPopup();">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlFrame" runat="server" CssClass="pnlFilter" Style="display: none; width: 320px; height: 94px">
        <div class="Purchaseheader" runat="server">
            New Frame &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Press
            esc to close
        </div>

        <table style="width: 100%; border-collapse: collapse">
            <tr>
                <td align="center">
                    <asp:Label ID="lblFrame" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
                </td>

            </tr>
            <tr>
                <td>Frame :&nbsp;
            <asp:TextBox ID="txtNFrame" runat="server" ClientIDMode="Static" Font-Bold="true" MaxLength="20"></asp:TextBox>
                    <asp:Label ID="Label5" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                </td>

            </tr>
        </table>

        <div class="filterOpDiv">
            <input id="btnSaveCity" type="button" class="ItDoseButton" value="Save" onclick="SaveFrameMaster()" />
            &nbsp;<asp:Button ID="btnRCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" />
        </div>
    </asp:Panel>

  <cc1:ModalPopupExtender ID="mpeCreateFrameHeader" runat="server" CancelControlID="btnRCancelHeader"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlMenuHeader" PopupDragHandleControlID="dragHandle" BehaviorID="mpeCreateFrameHeader" OnCancelScript="ClearHeaderPopup();">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlMenuHeader" runat="server" CssClass="pnlFilter" Style="display: none; width: 320px; height: 94px">
        <div id="Div1" class="Purchaseheader" runat="server">
            New Frame &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Press
            esc to close
        </div>

        <table style="width: 100%; border-collapse: collapse">
            <tr>
                <td align="center">
                    <asp:Label ID="lblHeaderNameError" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" Text=" " />
                </td>

            </tr>
            <tr>
                <td> Header Menu Name  :&nbsp;
            <asp:TextBox ID="txtHeaderName" runat="server" ClientIDMode="Static" Font-Bold="true" MaxLength="20"></asp:TextBox>
                    <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                </td>

            </tr>
        </table>

        <div class="filterOpDiv">
            <input id="btnMenuHeader" type="button" class="ItDoseButton" value="Save" onclick="SaveFrameMasterMenuHeader()" />
            &nbsp;<asp:Button ID="btnRCancelHeader" runat="server" CssClass="ItDoseButton" Text="Cancel" />
        </div>
    </asp:Panel>



</asp:Content>
