

<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="EditIPDAdvanceReceipt.aspx.cs" Inherits="Design_Utility_EditIPDAdvanceReceipt" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>    
            <div id="Pbody_box_inventory" >
                <div class="POuter_Box_Inventory">
                    <div class="content" style="text-align:center;">
                            <b>Edit IPD Advance Receipt</b>&nbsp;<br />
                            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                    </div>
                </div>
                <div class="POuter_Box_Inventory" id="divSearch" runat="server">
                     <div class="Purchaseheader">
                        Searching Criteria
                     </div>
                    <table style="width: 89%">
                        <tr>
                            <td style="text-align:right;">
                                From Date :&nbsp;
                            </td>
                            <td>
                                <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" Width="129px" TabIndex="1" ClientIDMode="Static" ></asp:TextBox>
                               <cc1:CalendarExtender ID="cdFrom" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy" ClearTime="true" ></cc1:CalendarExtender></td>
                            <td  style="text-align:right;">
                                To Date :&nbsp;
                            </td>
                            <td >
                                  <asp:TextBox ID="ucToDate" runat="server" ToolTip="Click To Select To Date" Width="129px" TabIndex="3" ClientIDMode="Static"></asp:TextBox>
                                  <cc1:CalendarExtender ID="cdTo" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy" ClearTime="true"></cc1:CalendarExtender>
                           </td>
                        </tr>
                       
                        <tr>
                            <td   style="text-align:right;">
                                IP No. :&nbsp;</td>
                            <td>
                                <asp:TextBox ID="txtIPNo" runat="server" Width="100px"></asp:TextBox>    &nbsp;</td>
                            <td  style="text-align:right;">
                                &nbsp;</td>
                            <td >
                                 &nbsp;</td>
                        </tr>
                       
                    </table>
                </div>
                   <div class="POuter_Box_Inventory" style=" text-align:center">
                 <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search" Width="60px"
                                    OnClick="btnSearch_Click" />
                </div> 
                
                <div id="divDetail" runat="server" visible="false">
                 <div class="POuter_Box_Inventory" style=" text-align:left">
                 <asp:Button ID="btnGreen" runat="server" CssClass="ItDoseButton" BackColor="LightGreen" ForeColor="Black" Text="Already Deducted Receipts"
                      OnClick="btnGreen_Click" />
                     <asp:Button ID="btnActual" runat="server" CssClass="ItDoseButton" BackColor="Transparent" ForeColor="Black" Text="Actual Receipts"
                      OnClick="btnActual_Click" /><br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:blue;">Note : If click on <b>'In Amt'</b> Checkbox then deduction Apply on the <b>Amount</b> basis otherwise Discount Apply on the <b>Percent(%)</b> basis</span>
                </div>             
                 <div class="POuter_Box_Inventory" style=" text-align:center; max-height:260px;overflow:scroll;">
                             <asp:GridView AutoGenerateColumns="False" CssClass="GridViewStyle" ID="grvdetail" runat="server" Width="99.8%" OnRowDataBound="grvdetail_RowDataBound" >
                                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                            <Columns>
                                            <asp:TemplateField>
                                            <HeaderTemplate>
                                            <asp:CheckBox runat="server" ID="chkSelectAll" Checked="true" CssClass="chkHeader" Text="All"/>
                                            </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:CheckBox runat="server" ID="chkSelect" Checked="true" CssClass="chkItem" />
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="50px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="50px" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="S.No.">
                                                    <ItemTemplate>
                                                        <%# Container.DataItemIndex+1 %>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="50px" />
                                                </asp:TemplateField>
                                               <asp:TemplateField HeaderText="IP No.">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="lblTransactionID" Text='<%# Eval("TransactionID") %>' />
                                                        <asp:Label runat="server" ID="lblIsRevert" Text='<%# Eval("IsRevert") %>' Visible="false" />
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="50px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="50px" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Patient Name">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="lblPName" Text='<%# Eval("PName") %>' />
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="150px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center"  Width="100px"  />
                                                </asp:TemplateField>
                                              
                                                <asp:TemplateField HeaderText="Panel">
                                                    <ItemTemplate>
                                                       <asp:Label runat="server" ID="lblPanel" Text='<%# Eval("Panel") %>' />  
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewItemStyle" Width="80px"  />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center"  Width="80px"  />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Receipt Date">
                                                    <ItemTemplate>
                                                       <asp:Label runat="server" ID="lblDate" Text='<%# Eval("Date") %>' />  
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewItemStyle"  HorizontalAlign="Center" Width="80px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="100px" />
                                                </asp:TemplateField>
                                                 <asp:TemplateField HeaderText="Receipt No.">
                                                    <ItemTemplate>
                                                       <asp:Label runat="server" ID="lblReceiptNo" Text='<%# Eval("ReceiptNo") %>' />  
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewItemStyle"  Width="120px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="200px" />
                                                </asp:TemplateField>
                                                 <asp:TemplateField HeaderText="Actual Received Amt.">
                                                    <ItemTemplate>
                                                       <asp:Label runat="server" ID="lblActualAmountPaidTotal" Text='<%# Eval("ActualAmountPaid") %>' ClientIDMode="Static" />  
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewItemStyle" Width="100px" HorizontalAlign="Right" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center"  Width="100px"  />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Current Received Amt.">
                                                    <ItemTemplate>
                                                       <asp:Label runat="server" ID="lblAmountPaidTotal" Text='<%# Eval("AmountPaid") %>' ClientIDMode="Static" />  
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewItemStyle" Width="100px" HorizontalAlign="Right" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center"  Width="100px"  />
                                                </asp:TemplateField>
                                                 <asp:TemplateField HeaderText="Dedu cted Amt.">
                                                    <ItemTemplate>
                                                       <asp:Label runat="server" ID="lblDeductedAmt" Text='<%# Util.GetFloat(Eval("ActualAmountPaid"))- Util.GetFloat(Eval("AmountPaid")) %>' ClientIDMode="Static" />  
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewItemStyle" Width="50px" HorizontalAlign="Right" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center"  Width="50px"  />
                                                </asp:TemplateField>
                                                 <asp:TemplateField HeaderText="Received In Cash">
                                                    <ItemTemplate>
                                                       <asp:Label runat="server" ID="lblAmountPaidInCash" Text='<%# Eval("AmountPaidInCash") %>' ClientIDMode="Static" />  
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewItemStyle" Width="100px"  HorizontalAlign="Right" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="100px"  />
                                                </asp:TemplateField>
                                                 <asp:TemplateField>
                                                      <HeaderTemplate>
                                                          Deduct <br /><asp:CheckBox runat="server" ID="chkDeductInAmt" CssClass="DeductInAmt" ClientIDMode="Static" Text="In Amt"/>
                                                          <br />
                                                          <asp:TextBox ID="txtDeductAll" runat="server" MaxLength="7" ClientIDMode="Static" onkeyup="ApplyDeductAmount(this);" Width="60px"> </asp:TextBox>
                                                               <cc1:FilteredTextBoxExtender ID="f1" runat="server" FilterType="Numbers" TargetControlID="txtDeductAll" ></cc1:FilteredTextBoxExtender>
                                                         
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:TextBox runat="server" ID="txtDeductAmt" Width="60px" onkeyup="ValidateAmount(this);" MaxLength="7" ClientIDMode="Static" />
                                                        <cc1:FilteredTextBoxExtender ID="f1" runat="server" FilterType="Numbers,Custom" TargetControlID="txtDeductAmt" ValidChars="." ></cc1:FilteredTextBoxExtender>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="80px"  />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Right" Width="80px"  />
                                                </asp:TemplateField>
                                                 <asp:TemplateField HeaderText="New Received Amt.">
                                                    <ItemTemplate>
                                                       <asp:Label runat="server" ID="lblNewReceiptAmt" Text='<%# Eval("AmountPaid") %>' ClientIDMode="Static" />  
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewItemStyle" Width="100px" HorizontalAlign="Right"  />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="100px"  />
                                                </asp:TemplateField>
                                               
                                            </Columns>
                                        </asp:GridView>
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="content" style="text-align: center;">   
                      <asp:Label ID="lblTotal" runat="server" Font-Size="Medium" ClientIDMode="Static" CssClass="ItDoseLblError"></asp:Label>
                     </div>
                </div>
                  <div class="POuter_Box_Inventory">
                    <div class="content" style="text-align: left;">   
                       &nbsp;&nbsp;Reason :&nbsp; <asp:TextBox runat="server" ID="txtReason" Width="600px" MaxLength="100" />
                     </div>
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="content" style="text-align: center">   
                      <asp:Button ID="btnUpdate" runat="server" CssClass="ItDoseButton" Text="Update" OnClick="btnUpdate_Click" Visible="False" />
                       <asp:Button ID="btnRevert" runat="server" CssClass="ItDoseButton" Text="Revert" OnClick="btnRevert_Click" Visible="False" />
                    </div>
                </div>

              </div> 
            </div>
  
 <script type="text/javascript"> 
  $(document).ready(function() {          
    var headerChk = $(".chkHeader input");
    var itemChk = $(".chkItem input");
    headerChk.click(function () { 
     itemChk.each(function () { 
      this.checked = headerChk[0].checked; }) 
    });
    itemChk.each(function () {
      $(this).click(function () {
        if (this.checked == false) { headerChk[0].checked = false; }
      })
    });

    $(".DeductInAmt input").click(function () {
        var PaidIncash = 0, DeduacAmt = 0, NewReceiptAmt = 0, PaidAmt = 0,TotalPaidAmt=0,TotalNewPaidAmt=0,TotalDiffAmt=0;
        $("#<%=grvdetail.ClientID %> tr").each(function () {
            if (!this.rowIndex)
                return;

            PaidIncash =  $(this).closest("tr").find("#lblAmountPaidInCash").text();
            PaidAmt =  $(this).closest("tr").find("#lblAmountPaidTotal").text();
            DeductAmt = $(this).closest("tr").find("#txtDeductAmt").val();
            if (isNaN(PaidIncash) || (PaidIncash == "")) PaidIncash = 0;
            if (isNaN(PaidAmt) || (PaidAmt == "")) PaidAmt = 0;
            if (isNaN(DeductAmt) || (DeductAmt == "")) DeductAmt = 0;
            if (($(".DeductInAmt input"))[0].checked)
                DeductAmt = DeductAmt;
            else
                DeductAmt = parseFloat(PaidAmt) * parseFloat(DeductAmt) * 0.01;

            if (parseFloat(DeductAmt) > parseFloat(PaidIncash)) {
                $(this).closest("tr").find("#txtDeductAmt").val('0');
                DeductAmt = 0;
            }
            NewReceiptAmt = parseFloat(PaidAmt) - parseFloat(DeductAmt);
            if ($(this).closest("tr").find(".chkItem input")[0].checked) {
                TotalPaidAmt = parseFloat(TotalPaidAmt) + parseFloat(PaidAmt);
                TotalNewPaidAmt = parseFloat(TotalNewPaidAmt) + parseFloat(NewReceiptAmt);
                TotalDiffAmt = parseFloat(TotalDiffAmt) + parseFloat(DeductAmt);
            }
            $(this).closest("tr").find("#lblNewReceiptAmt").text(NewReceiptAmt.toFixed(2));
        });

        $("#lblTotal").text('Current Total Received Amount is Rs. ' + TotalPaidAmt.toFixed(2) + ' , New Total Received Amount is Rs. ' + TotalNewPaidAmt.toFixed(2) + ' and Difference is Rs. ' + TotalDiffAmt.toFixed(2));
    });
  });

   function ApplyDeductAmount(txt)
     {
         var PaidIncash = 0, DeduacAmt = 0, NewReceiptAmt = 0, PaidAmt = 0, TotalPaidAmt = 0, TotalNewPaidAmt = 0, TotalDiffAmt = 0;
         $("#<%=grvdetail.ClientID %> tr").each(function () {
      if (!this.rowIndex)
          return;

      DeductAmt = $(txt).val();
      $(this).closest("tr").find("#txtDeductAmt").val(DeductAmt);
      PaidIncash = $(this).closest("tr").find("#lblAmountPaidInCash").text();
      PaidAmt = $(this).closest("tr").find("#lblAmountPaidTotal").text();
      if (isNaN(PaidIncash) || (PaidIncash == "")) PaidIncash = 0;
      if (isNaN(PaidAmt) || (PaidAmt == "")) PaidAmt = 0;
      if (isNaN(DeductAmt) || (DeductAmt == "")) DeductAmt = 0;
      if (($(".DeductInAmt input"))[0].checked)
          DeductAmt = DeductAmt;
      else
          DeductAmt = parseFloat(PaidAmt) * parseFloat(DeductAmt) * 0.01;

      if (parseFloat(DeductAmt) > parseFloat(PaidIncash)) {
          $(this).closest("tr").find("#txtDeductAmt").val('0');
          DeductAmt = 0;
      }
      NewReceiptAmt = parseFloat(PaidAmt) - parseFloat(DeductAmt);
      if (parseFloat(DeductAmt) > 0)
          $(this).closest("tr").find(".chkItem input").attr('checked', 'checked');
      else
          $(this).closest("tr").find(".chkItem input").removeAttr('checked');

      if ($(this).closest("tr").find(".chkItem input")[0].checked) {
          TotalPaidAmt = parseFloat(TotalPaidAmt) + parseFloat(PaidAmt);
          TotalNewPaidAmt = parseFloat(TotalNewPaidAmt) + parseFloat(NewReceiptAmt);
          TotalDiffAmt = parseFloat(TotalDiffAmt) + parseFloat(DeductAmt);
      }
      $(this).closest("tr").find("#lblNewReceiptAmt").text(NewReceiptAmt.toFixed(2));
  });

  $("#lblTotal").text('Current Total Received Amount is Rs. ' + TotalPaidAmt.toFixed(2) + ' , New Total Received Amount is Rs. ' + TotalNewPaidAmt.toFixed(2) + ' and Difference is Rs. ' + TotalDiffAmt.toFixed(2));

     }
  function ValidateAmount(txt)
  {
      var PaidIncash = 0, DeduacAmt = 0, NewReceiptAmt = 0, PaidAmt = 0, TotalPaidAmt = 0, TotalNewPaidAmt = 0, TotalDiffAmt = 0;
      var row = $(txt).closest("tr");
       PaidIncash = $(row).find("#lblAmountPaidInCash").text();
       PaidAmt = $(row).find("#lblAmountPaidTotal").text();
       DeductAmt = $(row).find("#txtDeductAmt").val();
       if (isNaN(PaidIncash) || (PaidIncash == "")) PaidIncash = 0;
       if (isNaN(PaidAmt) || (PaidAmt == "")) PaidAmt = 0;
       if (isNaN(DeductAmt) || (DeductAmt == "")) DeductAmt = 0;

        if (($(".DeductInAmt input"))[0].checked)
            DeductAmt = DeductAmt;
        else
            DeductAmt = parseFloat(PaidAmt) * parseFloat(DeductAmt) * 0.01;
       
          if (parseFloat(DeductAmt) > parseFloat(PaidIncash)) {
              alert('Deduact Amt should be less than or equal to Paid In Cash Amt.');
              $(row).find("#txtDeductAmt").val('0');
              DeductAmt = 0;
          }
          NewReceiptAmt = parseFloat(PaidAmt) - parseFloat(DeductAmt);
          $(row).find("#lblNewReceiptAmt").text(NewReceiptAmt.toFixed(2));
          if (parseFloat(DeductAmt) > 0)
              $(row).find(".chkItem input").attr('checked', 'checked');
          else
              $(row).find(".chkItem input").removeAttr('checked');
          
          $("#<%=grvdetail.ClientID %> tr").each(function () {
              if (!this.rowIndex)
                  return;
              if ($(this).closest("tr").find(".chkItem input")[0].checked) {
                  PaidAmt = $(this).closest("tr").find("#lblAmountPaidTotal").text();
                  NewReceiptAmt = $(this).closest("tr").find("#lblNewReceiptAmt").text();
                  if (isNaN(NewReceiptAmt) || (NewReceiptAmt == "")) NewReceiptAmt = 0;
                  if (isNaN(PaidAmt) || (PaidAmt == "")) PaidAmt = 0;

                  TotalPaidAmt = parseFloat(TotalPaidAmt) + parseFloat(PaidAmt);
                  TotalNewPaidAmt = parseFloat(TotalNewPaidAmt) + parseFloat(NewReceiptAmt);
                  TotalDiffAmt = parseFloat(TotalPaidAmt) - parseFloat(TotalNewPaidAmt);
              }
          });
      $("#lblTotal").text('Current Total Received Amount is Rs. ' + TotalPaidAmt.toFixed(2) + ' , New Total Received Amount is Rs. ' + TotalNewPaidAmt.toFixed(2) + ' and Difference is Rs. ' + TotalDiffAmt.toFixed(2));

  }
      </script> 
</asp:Content>
