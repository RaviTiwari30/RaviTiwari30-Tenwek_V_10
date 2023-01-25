<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="IntercomSearch.aspx.cs" Inherits="Design_OPD_IntercomSearch" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <script type="text/javascript">
        var keys = [];
        var values = [];
        $(document).ready(function () {
            var options = $('#<% = lstIntercom.ClientID %> option');
            $.each(options, function (index, item) {
                keys.push(item.value);
                values.push(item.innerHTML);
            });

            $('#<% = txtSearch.ClientID %>').keyup(function (e) {
                searchByFirstChar(document.getElementById('<%=txtSearch.ClientID%>'), document.getElementById('<%=txtcpt.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstIntercom.ClientID%>'), document.getElementById('btnAdd'), values, keys, e)
                LoadDetail()
            });
            $('#<%=txtcpt.ClientID %>').keyup(function (e) {
                searchByCPTCode(document.getElementById('<%=txtSearch.ClientID%>'), document.getElementById('<%=txtcpt.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstIntercom.ClientID%>'), document.getElementById('btnAdd'), values, keys, e)
                LoadDetail()
            });
            $('#<%=txtInBetweenSearch.ClientID %>').keyup(function (e) {
                searchByInBetween(document.getElementById('<%=txtSearch.ClientID%>'), document.getElementById('<%=txtcpt.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstIntercom.ClientID%>'), document.getElementById('btnAdd'), values, keys, e)
                LoadDetail()
            });
        });

        function LoadDetail() {
            var strItem = $('#<%=lstIntercom.ClientID %>').val();
            if ((strItem != null) && (strItem != "0.00")) {
                $('#lblName').text(strItem.split('#')[0]);
                $('#lblNumber').text(strItem.split('#')[1]);
            }
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Intercom Search</b>
            <br />

            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Intercom Search
            </div>

            <table style="width: 100%;">
                <tr style="display: none">
                    <td style="width: 30%; text-align: right;"></td>
                    <td style="width: 20%; text-align: left;">
                        <asp:TextBox ID="txtSearch" AutoCompleteType="Disabled" ClientIDMode="Static"
                            runat="server" Width="380px"/>
                    </td>
                    <td style="text-align: right; width: 20%">
                        <asp:Button ID="btnAdd" runat="server" ClientIDMode="Static" Text="Add" />
                    </td>
                    <td style="width: 30%; text-align: left;">&nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="width: 30%; text-align: right;">Search By Any Name :&nbsp;</td>
                    <td style="width: 20%; text-align: left;">

                        <asp:TextBox ID="txtInBetweenSearch" runat="server" CssClass="ItDoseTextinputText" TabIndex="1" AutoCompleteType="Disabled" ClientIDMode="Static"
                            Width="408px" />
                    </td>
                    <td style="text-align: right; width: 20%">Extension No. :&nbsp;</td>
                    <td style="width: 30%; text-align: left;">
                        <asp:TextBox ID="txtcpt" runat="server" Width="150px" CssClass="ItDoseTextinputText" AutoCompleteType="Disabled" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 30%; text-align: right;">&nbsp;
                    </td>
                    <td style="width: 70%; text-align: left;" colspan="3">
                        <asp:ListBox ID="lstIntercom" runat="server" CssClass="ItDoseDropdownbox" Height="150px" ClientIDMode="Static" onchange="LoadDetail()"
                            TabIndex="4" Width="420px"></asp:ListBox>

                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                  <div class="col-md-21">
                        <asp:Label ID="lblName" runat="server" ClientIDMode="Static" Font-Bold="true" Font-Size="XX-Large" ForeColor="Red"></asp:Label>
                  </div><div class="col-md-3">
                        <asp:Label ID="lblNumber" runat="server" ClientIDMode="Static" Font-Bold="true" Font-Size="XX-Large" ForeColor="Red"></asp:Label>
               </div>
            </div>
        </div>
    </div>
</asp:Content>

