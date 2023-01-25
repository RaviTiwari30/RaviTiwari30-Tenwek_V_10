<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PRNormsReport.aspx.cs" Inherits="Design_Purchase_PRNormsReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">

            <b>Purchase Request Norms Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />

        </div>

        <div class="POuter_Box_Inventory">
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style=" width: 20%;text-align:right" >Store Type :&nbsp;
                       
                    </td>
                    <td style="width: 20%;text-align:left">
                        <asp:RadioButtonList ID="rdoStoretype" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                            <asp:ListItem Selected="True" Value="STO00001">Medical Items</asp:ListItem>
                            <asp:ListItem Value="STO00002">General Items</asp:ListItem>

                        </asp:RadioButtonList>
                    </td>
                  
                </tr>
                  <tr>
                    <td style=" width: 15%;text-align:right">Department :&nbsp;
                       
                    </td>
                    <td style="width: 20%;text-align:left">
                       <asp:DropDownList ID="ddlStoreDepartment" runat="server" Width="170px"></asp:DropDownList>
                    </td>
                  
                </tr>
            </table>

        </div>
                <div class="POuter_Box_Inventory" style="text-align:center">
             <asp:Button ID="btnReport" runat="server" CssClass="ItDoseButton" Text="Report" OnClick="btnReport_Click" />
            </div>
    </div>
</asp:Content>

