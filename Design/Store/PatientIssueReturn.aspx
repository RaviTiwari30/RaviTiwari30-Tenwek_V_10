<%@ Page Language="C#" MaintainScrollPositionOnPostback="true" AutoEventWireup="true"
    CodeFile="PatientIssueReturn.aspx.cs" Inherits="Design_Store_PatientIssueReturn"
     %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
            <script type="text/javascript" src="../../Scripts/Message.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $('#ucDateFrom').change(function () {
                ChkDate();

            });

            $('#ucDateTo').change(function () {
                ChkDate();

            });

        });

       

        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucDateFrom').val() + '",DateTo:"' + $('#ucDateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnSearch,#btnPrint,#btnSummary').attr('disabled', 'disabled');
                        $("#<%=grdSearch.ClientID %>").remove();

                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch,#btnPrint,#btnSummary').removeAttr('disabled');
                    }
                }
            });

        }
 
    </script>
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <b>Patient Medical Issue / Return Detail</b>&nbsp;<br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"  ClientIDMode="Static"/>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Issue - Return Detail</div>
                <div style="text-align: center">
                    <table cellpadding="0" cellspacing="0" style="width: 100%">
                        
                        <tr>
                            <td style="text-align: center;" class="ItDoseLabel" colspan="4">
                                <asp:DropDownList ID="ddlStts" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStts_SelectedIndexChanged">
                                    <asp:ListItem Text="All" Selected="True" Value="All"></asp:ListItem>
                                    <asp:ListItem Text="Issue" Value="Issue"></asp:ListItem>
                                    <asp:ListItem Text="Return" Value="Return"></asp:ListItem>
                                </asp:DropDownList>
                                &nbsp;From Date:
                               
                                <asp:TextBox ID="ucDateFrom" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"
                            TabIndex="2"  Width="120px"></asp:TextBox>
                        <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="ucDateFrom" Format="dd-MMM-yyyy"
                            Animated="true" runat="server"> </cc1:CalendarExtender>
                                 To Date:
                               
                               <asp:TextBox ID="ucDateTo" runat="server" ClientIDMode="Static" ToolTip="Click To Select To Date"
                            TabIndex="3" Width="120px"></asp:TextBox>
                        <cc1:CalendarExtender ID="ToDatecal" TargetControlID="ucDateTo" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                                &nbsp;
                                <asp:Button ID="btnSearch"  CssClass="ItDoseButton" runat="server" OnClick="btnSearch_Click" Text="Search"  ClientIDMode="Static"/>
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" style="text-align: right; display: none;">
                                <asp:CheckBoxList ID="chkItemType" runat="server" RepeatDirection="Horizontal" CssClass="ItDoseLabel">
                                    <asp:ListItem Selected="True" Value="'GP'">GP</asp:ListItem>
                                    <asp:ListItem Selected="True" Value="'HS'">HS</asp:ListItem>
                                    <asp:ListItem Selected="True" Value="'IMP'">IMP</asp:ListItem>
                                </asp:CheckBoxList>
                            </td>
                                <td style="text-align: center; width= 100px">
                                <asp:CheckBoxList ID="chkPkgType" runat="server" RepeatDirection="Horizontal" 
                                        CssClass="ItDoseLabel" Width="294px">
                                    <asp:ListItem Selected="True" Value="0">Included in Pkg</asp:ListItem>
                                    <asp:ListItem Selected="True" Value="1">Not-Included in Pkg</asp:ListItem>
                                    
                                </asp:CheckBoxList></td>
                        </tr>
                        <tr>
                            <td style="text-align: center; height: 10px;" colspan="4">
                                <asp:Label ID="lblIssue" runat="server"  BackColor="#99FFCC"
                                    ForeColor="Black"></asp:Label>
                                &nbsp;<asp:Label ID="lblReturn"  runat="server" BackColor="#FF99CC"
                                    ForeColor="White"></asp:Label>
                                &nbsp;<asp:Label ID="lblBilledIssue"  runat="server" BackColor="#FF8000"
                                    ForeColor="White"></asp:Label>
                                &nbsp;<asp:Label ID="lblNotBilledIssue"  runat="server" BackColor="#804000"
                                    ForeColor="White"></asp:Label>
                                &nbsp;<asp:Label ID="lblNotBilledReturn"  runat="server" BackColor="#C0C0FF"
                                    ForeColor="Black"></asp:Label>
                                &nbsp;<asp:Label ID="lblBilledReturn"  runat="server" BackColor="Fuchsia"
                                    ForeColor="White"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" style="width: 15%">
                                <asp:GridView ID="grdSearch" runat="server" OnRowDataBound="grdSearch_RowDataBound"
                                    CssClass="GridViewStyle" AutoGenerateColumns="False" OnRowCommand="grdSearch_RowCommand">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="#">
                                            <ItemTemplate>
                                                <%#Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="15px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Print">
                                            <HeaderTemplate>
                                                <input type="checkbox" id="chkbxslctal" runat="server" title="Select" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkbx" Visible='<%# Util.getbooleanTrueFalse(Eval("BillNo"))  %>'
                                                    runat="server" />
                                                <asp:Label ID="lblTypeOfTnxHDN" Visible="false" Text='<%#Eval("TypeOfTnx") %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="15px" />
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="Date" HeaderText="Date">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="IndentNo" HeaderText="Requisition No.">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ItemName" HeaderText="Item Name">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="175px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="BatchNumber" HeaderText="Batch">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="MRP" HeaderText="Selling Price">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="SoldUnits" HeaderText="Qty.">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Amount" HeaderText="Amount">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="BillAmount" HeaderText="Bill Amt.">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="BillStatus" HeaderText="Billing" Visible="false">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                        </asp:BoundField>
                                        <asp:TemplateField HeaderText="Type">
                                            <ItemTemplate>
                                                <asp:Label ID="lbltype" Text='<%#Eval("TypeOfTnx") %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="15px" />
                                        </asp:TemplateField>
                                        
                                        <asp:BoundField DataField="Dept" HeaderText="Dept.">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                        </asp:BoundField>
                                        <asp:TemplateField HeaderText="Bill No.">
                                            <ItemTemplate>
                                                <asp:Label ID="lblbillnoHDN" Text='<%#Eval("BillNo") %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="15px" />
                                        </asp:TemplateField>
                                        
                                        <asp:TemplateField HeaderText="Requisition">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="imbView" runat="server" Visible='<%# Util.getbooleanTrueFalse(Eval("IndentNo"))  %>'
                                                    CausesValidation="false" CommandName="AView" ImageUrl="~/Images/view.GIF"
                                                    CommandArgument='<%# Eval("IndentNo") %>' />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" HorizontalAlign="Center"/>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Invoice" Visible="false">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="imbInvoiceView" runat="server" Visible='<%# Util.GetBoolean(Eval("IsInvoice"))  %>'
                                                    CausesValidation="false" CommandName="IView" ImageUrl="~/Images/view.GIF"
                                                    CommandArgument='<%# Eval("BillNo")+"#"+ Eval("TypeOfTnx") +"#"+Eval("TransactionID") %>' />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle"  HorizontalAlign="Center"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Type" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTID" Text='<%#Eval("TransactionID") %>' runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="15px" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </td>
                        </tr>
                        <tr style="text-align: center;">
                            <td>
                                <asp:Button ID="btnPrint" OnClientClick="PrintChk(); return false;" runat="server"
                                    Text="Print"  ClientIDMode="Static"  style="display:none" CssClass="ItDoseButton"/>
                                &nbsp;
                                <asp:Button ID="btnSummary" OnClick="btnSummary_Click" style="display:none" runat="server" Text="Summary" ClientIDMode="Static" CssClass="ItDoseButton"/>
                            </td>
                        </tr>
                    </table>
                    &nbsp;&nbsp;</div>
            </div>
        </div>
    </form>

  

    <script type="text/javascript">
 var objoldval="";
 function calpopup()
 {
 var gv=document.getElementById('<%=grdSearch.ClientID %>');
  var grdlngth=gv.rows.length;
   for(var j=1; j<=grdlngth-1; j++)
       {
              var obj=((gv.rows[j].cells[1]).firstChild);
              if(obj!=null)
              {
              if(obj.checked==true)
              {
              var obj1=((gv.rows[j].cells[13]).firstChild);
              var obj1val=obj1.innerHTML;
              var typeoftnx=((gv.rows[j].cells[11]).firstChild);
              var typeoftnxval=typeoftnx.innerHTML;
              
              var TID = ((gv.rows[j].cells[16]).firstChild);
              
              if(objoldval==obj1val)
              {
             
              }
              else
              {
              objoldval=obj1.innerHTML;
              
              window.open('InternalStockTransferPatientRecipt.aspx?bilno='+obj1val+'&typeOftnx='+typeoftnxval+'&TID='+TID.innerHTML);
              }
              
              }
           }
       }
 }
 
 
function  chkall()
{
var gv=document.getElementById('<%=grdSearch.ClientID %>');
var grdlngth=gv.rows.length;
   for(var j=1; j<=grdlngth-1; j++)
       {
              var obj=((gv.rows[j].cells[1]).firstChild);
              if(obj!=null)
              {
              if(obj.checked==true)
              {
              ((gv.rows[j].cells[1]).firstChild.checked)=false;
              }
              else
              {
              ((gv.rows[j].cells[1]).firstChild.checked)=true;
              }
              }
     }
   }
   
      $(document).ready(function() {
$("#grdSearch_ctl01_chkbxslctal").click(function() {
$(":checkbox").attr('checked',this.checked);

 
 });
  });
   
 function PrintChk() {
  
  var objoldval="";
  $('#<%=grdSearch.ClientID %> tr').each(function(){
  
  
 if( $(this).find('td:eq('+1+')').find(":checkbox").attr('checked'))
 {

var obj1val=$(this).find('td:eq('+13+')').text().trim();
var typeoftnxval=$(this).find('td:eq('+11+')').text().trim();
var TID=$(this).find('td:eq('+16+')').text().trim();

if(objoldval==obj1val)
              {
             
              }
              else
              {
              objoldval=obj1val;
              window.open('InternalStockTransferPatientRecipt.aspx?bilno='+obj1val+'&typeOftnx='+typeoftnxval+'&TID='+TID);
}




 }
  
  
  
  });
  
  
}
 


    </script>

</body>
</html>
