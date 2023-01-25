<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="ActivateItem.aspx.cs" Inherits="Design_EDP_ActivateItem" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>Activate / DeActivate Doctor-Employee</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>

        <div class="POuter_Box_Inventory">

            <Ajax:UpdatePanel ID="UpdatePanel6" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <table style="WIDTH: 100%; border-collapse: collapse">
                        <tbody>
                            <tr>
                                <td style="width: 25%; text-align: right">Select Type: &nbsp;</td>
                                <td style="width: 25%; text-align: left">
                                    <asp:RadioButtonList
                                        ID="rdbType" runat="server"
                                        OnSelectedIndexChanged="rdbType_SelectedIndexChanged" AutoPostBack="True"
                                        RepeatDirection="Horizontal" ToolTip="Select  Employee Or Doctor">
                                        <asp:ListItem Selected="True" Value="0">Employee</asp:ListItem>
                                        <asp:ListItem Value="1">Doctor</asp:ListItem>
                                    </asp:RadioButtonList></td>
                            </tr>
                            <tr>
                                <td style="width: 25%; text-align: right"></td>
                                <td style="WIDTH: 25%;">&nbsp;<asp:RadioButtonList
                                    ID="rbtActive" runat="server"
                                    OnSelectedIndexChanged="rbtActive_SelectedIndexChanged" AutoPostBack="True"
                                    RepeatDirection="Horizontal" Width="197px"
                                    ToolTip="Select Item Active Or In-Active">
                                    <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                                    <asp:ListItem Value="0">InActive</asp:ListItem>
                                </asp:RadioButtonList>
                                </td>
                                <td style="width: 50%;" colspan="2"></td>
                            </tr>
                        </tbody>
                    </table>
                </ContentTemplate>
            </Ajax:UpdatePanel>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Remove Selection To De-Activate&nbsp;
            </div>
            <div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">

                            <div class="col-md-3">
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Search By Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                 <input type="text" id="txtSearch" onkeyup="SearchCheckbox(this,'#chkItem')"  />
                            </div>
                            <div class="col-md-8">
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </div>
            <div class="content">
                <Ajax:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:CheckBoxList ID="chkItem" runat="server" RepeatColumns="4" ClientIDMode="Static"
                            RepeatDirection="Horizontal" Width="956px"
                            ToolTip="Check To Acvtive Or De-Active">
                        </asp:CheckBoxList>
                    </ContentTemplate>
                    <Triggers>
                        <Ajax:AsyncPostBackTrigger ControlID="rbtActive" EventName="SelectedIndexChanged"></Ajax:AsyncPostBackTrigger>
                        <Ajax:AsyncPostBackTrigger ControlID="rdbType" EventName="SelectedIndexChanged"></Ajax:AsyncPostBackTrigger>
                    </Triggers>
                </Ajax:UpdatePanel>
                &nbsp;
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center">
                <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Width="60px"
                    Text="Save" OnClick="btnSave_Click" ToolTip="Click To Save " />
            </div>
        </div>
    </div>

</asp:Content>
