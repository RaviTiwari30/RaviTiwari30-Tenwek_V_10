<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RoomType_Role.aspx.cs" MasterPageFile="~/DefaultHome.master"
    Inherits="Design_EDP_RoomType_Role" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        function validate(btn) {
            $("#lblMsg").text('');
            //if ($(".chkLength input[type=checkbox]:checked").length == 0) {
            //    $("#lblMsg").text('Please Check Room Type');
            //    return false;
            //}

            if ($("#ddlLoginType").val() == "0") {
                $("#lblMsg").text('Please Select LoginType / Department');
                $("#ddlLoginType").focus();
                return false;
            }
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');

        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Bind RoomType with Department</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">
                                LoginType / Department 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlLoginType" CssClass="requiredField" ClientIDMode="Static" Width="95%" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlLoginType_SelectedIndexChanged">
                            </asp:DropDownList>
                            
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Floor
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlFloor" runat="server"  AutoPostBack="true" OnSelectedIndexChanged="ddlFloor_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                        
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Remove Selection To De-Activate&nbsp;<asp:CheckBox ID="chkSelectAll" runat="server"
                    AutoPostBack="True" Font-Bold="True" OnCheckedChanged="chkSelectAll_CheckedChanged"
                    Text="Select All" />
            </div>
            <table style="width: 100%" border="0">
                <tr>
                    <td style="text-align: left">
                        <asp:CheckBoxList ID="chkObservationType" CssClass="chkLength" ClientIDMode="Static" runat="server" RepeatColumns="4" RepeatDirection="Horizontal"
                            Width="956px">
                        </asp:CheckBoxList>
                    </td>
                </tr>
            </table>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center">

            <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Text="Save"
                OnClick="btnSave_Click" OnClientClick="return validate(this)" />
        </div>
    </div>

</asp:Content>
