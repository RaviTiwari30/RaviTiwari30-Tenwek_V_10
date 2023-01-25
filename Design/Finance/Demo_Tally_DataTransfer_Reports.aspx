
<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Demo_Tally_DataTransfer_Reports.aspx.cs" Inherits="Design_EDP_Demo_Tally_DataTransfer_Reports" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 

    <script type="text/javascript">
        $(document).ready(function () {
            getDate();       
        });


        function getDate() {
            serverCall('../Common/CommonService.asmx/getDate', {}, function (response) {
                $('#txtFromDate,#txtToDate').val(response);
            });
        }


        function ChkDate() {
            var data = {
                DateFrom: $('#txtFromDate').val(),
                DateTo: $('#txtToDate').val()
            }
            serverCall('../common/CommonService.asmx/CompareDate', data, function (response) {
                if (response == false) {
                    $('#spnMsg').text('To date can not be less than from date!');
                    $('#btnSearch').attr('disabled', 'disabled');
                }
                else {
                    $('#spnMsg').text('');
                    $('#btnSearch').removeAttr('disabled');
                }
            });
        }



      
    </script>
  
   
    <div id="Pbody_box_inventory">
          <Ajax:ScriptManager ID="ScriptManager1" runat="server" ScriptMode="Release">
    </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Finance Mapped Un-Mapped Item Reports</b><br />
            <asp:Label runat="server" CssClass="ItDoseLblError" ID="spnMsg" ClientIDMode="Static" ></asp:Label>
         
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <table id="Table1"  style="text-align: left; width: 953px;display:none">            
                <tr style="height: 27px;" >
                    <td style="text-align:right; width: 155px;">Tnx Type :&nbsp;</td>
                    <td style="width: 462px"> 
                        <asp:RadioButtonList ID="rblTnxType" runat="server" RepeatDirection="Horizontal" >
                            <asp:ListItem Selected="True" Value="Bill/Invoice">Total Revenue</asp:ListItem>
                            <asp:ListItem Value="Bill Cancel">Cancelled Revenue</asp:ListItem>                       
                        </asp:RadioButtonList>                    
                    </td>
                   <td style="text-align:right; width: 92px;"></td>
                   <td></td>
                </tr>           
                <tr style="height: 27px;" >
                   <td style="text-align:right; width: 155px;">Type :&nbsp;

                    </td>
                     <td style="width: 462px">
                      <asp:RadioButtonList ID="rdoType" runat="server" RepeatDirection="Horizontal" >
                          <asp:ListItem Selected="True" Value="1">Cash Collection</asp:ListItem>
                          <asp:ListItem Value="2">Bills</asp:ListItem>                       
                      </asp:RadioButtonList>
                      <%--<input type="radio" checked name="rdoType" value="1" />Cash Collection
                      <input type="radio" name="rdoType" value="2" />Detail--%>
                     <%--<input type="radio" name="rdoType" value="3" />Summary --%>
                        
                     </td>
                   <td class="trCenter" style="text-align:right; width: 92px;"><%--Centre :--%>&nbsp;</td>
                    <td class="trCenter">
                        <asp:CheckBox ID="chkBeforeTransfer" runat="server" Text="View Data Before Transfer" />
                        <asp:DropDownList Visible="false" ID="ddlCentre" Width="170px" runat="server" CssClass="form-control"   ClientIDMode="Static"></asp:DropDownList>
                    </td>
                </tr>
           
              <tr><td style="text-align:right; width: 155px;">From Date :&nbsp;</td>
                  <td style="width: 462px"><asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control"  Width="170px" ClientIDMode="Static" onchange="ChkDate();"></asp:TextBox>
                    <cc1:CalendarExtender ID="calFromDate"
                                runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender></td>
                 <td style="text-align:right; width: 92px;">To Date :&nbsp;</td>

                  <td style="width: 462px"><asp:TextBox ID="txtToDate" CssClass="form-control" runat="server"  Width="170px" ClientIDMode="Static" onchange="ChkDate();"></asp:TextBox>
                    <cc1:CalendarExtender ID="calToDate"
                                runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                  </td>
              </tr>
                <tr>
                    <td></td><td style="text-align:right;"> 
                       <%--<input type="button" id="btnSearch" class="btn ItDoseButton" value="Search" onclick="search()"  />--%>
                        <asp:Button ID="btnSearch" Text="Report" runat="server" OnClick="btnSearch_Click" CssClass="btn ItDoseButton" />
                       </td>
                    <td colspan="3" style="text-align: right;font-weight: bold;padding-top: 8px;">
                        <span style="color: #0000ff; font-size: 8.5pt" id="Note">
                            check box "View Data Before Transfer" will be disable if the items are not mapped
                        </span>
                     </td>

                </tr>
            </table>
            <div style="text-align:center">
                <asp:Button ID="btnMappedUnmappedReport" runat="server" OnClick="btnMappedUnmappedReport_Click" Text="Revenue Report" />
                &nbsp;&nbsp;&nbsp;
                <asp:CheckBox ID="chkMapped" runat="server" Text="Mapped Revenue Item" />
                 &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnMappedUnMappedPurchaseAccountReport" runat="server" OnClick="btnMappedUnMappedPurchaseAccountReport_Click" Text="Purchase Report" Visible="false" />
                &nbsp;&nbsp;&nbsp;
                <asp:CheckBox ID="chkMappedPurchase" runat="server" Text="Mapped Purchase Account Item" Visible="false" />
            </div>
        </div></div>
</asp:Content>

