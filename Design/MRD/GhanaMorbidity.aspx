<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="GhanaMorbidity.aspx.cs" Inherits="Design_MRD_GhanaMorbidity" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript" >
        $(function () {
            $('#EntryDate1').change(function () {
                ChkDate();

            });

            $('#EntryDate2').change(function () {
                ChkDate();

            });

        });

        

        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#EntryDate1').val() + '",DateTo:"' + $('#EntryDate2').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnPreview').attr('disabled', 'disabled');

                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnPreview').removeAttr('disabled');
                    }
                }
            });

        }
 
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Morbidity Report </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <div class="content">
              <asp:RadioButtonList ID="rdlSelect" runat="server" Visible="false" RepeatDirection="Horizontal" >
              <asp:ListItem Text ="PDF" Value="1" Selected="True" ></asp:ListItem>
              <asp:ListItem Text ="EXCEL" Value="2"></asp:ListItem>
              </asp:RadioButtonList>
                <div>
                    <table style="width:100%">
                        <tr>
                            <td align="right" style="width: 20%">
                                From Date :&nbsp;
                            </td>
                            <td style="width: 30%">
                                <asp:TextBox ID="EntryDate1" ClientIDMode="Static" runat="server" Width="170px"></asp:TextBox>
                                <cc1:CalendarExtender ID="calucDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="EntryDate1">
                                </cc1:CalendarExtender>
                            </td>
                            <td align="right" style="width: 20%">
                                To Date :&nbsp;
                            </td>
                            <td style="width: 30%">
                                <asp:TextBox ID="EntryDate2" runat="server" ClientIDMode="Static" Width="170px"></asp:TextBox>
                                <cc1:CalendarExtender ID="calucDate2" runat="server" Format="dd-MMM-yyyy" TargetControlID="EntryDate2">
                                </cc1:CalendarExtender>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnPreview" runat="server" OnClick="btnPreview_Click" Text="Preview"
                TabIndex="11" CssClass="ItDoseButton" ClientIDMode="Static"/>
        </div>
    </div>
</asp:Content>

