<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="UserPagemaster.aspx.cs" Inherits="Design_EDP_UserPagemaster" %>

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
            popup = window.open("browseDirectory.aspx?Frame=Rights", "view", "width="+ w +",height="+ h +",top="+ top +",left="+ left +"  ");
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
        function SaveAuthorizationPage() {
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


            obj.FileName = $("#txtFileName").val();
            obj.URL = $("#txtURL").val();

            data.push(obj);
            if (data.length > 0) {
                $.ajax({
                    url: "Services/EDP.asmx/SaveAuthorizePage",
                    data: JSON.stringify({ Data: data }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        if (result.d == "1") {
                            $("#lblMsg").text('Record Saved Successfully');

                            $("#txtFileName").val('');
                            $("#txtURL").val('');

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


        $(document).ready(function () {

        });
    </script>
    <div id="Pbody_box_inventory">
        <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <%--Ankur 14-08-15--%>
            <b>User Page Master</b>
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
                                File&nbsp;Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFileName" AutoCompleteType="Disabled" ClientIDMode="Static" runat="server" MaxLength="50" Width="95%"></asp:TextBox>
                            <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                URL
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-13">
                            <asp:TextBox ID="txtURL" runat="server" AutoCompleteType="Disabled" Font-Bold="true" MaxLength="70"
                                Width="240px" ClientIDMode="Static"></asp:TextBox>
                            <a href="javascript:void(0);" onclick="showDirectory();">
                                <img src="../../Images/view.GIF" style="border: none;" alt="" /></a>
                            <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                            <asp:Label ID="lblFile" runat="server" CssClass="ItDoseLabelSp" Text="(URL&nbsp; : /Design/Folder/FileName.aspx)"></asp:Label>
                        </div>

                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" value="Save" id="btnSave" onclick="SaveAuthorizationPage()" class="ItDoseButton" />
        </div>
    </div>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton" />
    </div>
    <cc1:ModalPopupExtender ID="mpeCreateFrame" runat="server" CancelControlID="btnRCancel"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlFrame" PopupDragHandleControlID="dragHandle" BehaviorID="mpeCreateFrame" OnCancelScript="ClearPopup();">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlFrame" runat="server" CssClass="pnlFilter" Style="display: none; width: 260px; height: 94px">
        <div id="Div1" class="Purchaseheader" runat="server">
            New Frame &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Press
            esc to close
        </div>

        <table width="100%">
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
</asp:Content>
