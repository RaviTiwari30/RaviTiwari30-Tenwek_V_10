<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RequisitionwiseCompareQuotation.aspx.cs" Inherits="Design_Store_RequisitionwiseCompareQuotation" MasterPageFile="~/DefaultHome.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
         <div id="Pbody_box_inventory">
          <div class="POuter_Box_Inventory" style="text-align: center">
            <b> Requisition wise Compare Quotation.</b><br />
              <asp:Label runat="server" CssClass="ItDoseLblError" ID="spnMsg" ClientIDMode="Static" ></asp:Label>
        </div>
         <div class="POuter_Box_Inventory" style="text-align: center">
             <div class="row">
                 <div class="col-md-3">
                     <label class="pull-left">Requisition No.</label>
                     <b class="pull-right">:</b>
                 </div>
                 <div class="col-md-5">
                   <asp:TextBox ID="txtRequisitionNo" runat="server" CssClass="requiredField" ToolTip="Please Enter Requisition No."></asp:TextBox>
                 </div>
                 </div>
             <div class="row">
                 <div class="col-md-24">
                     <asp:Button ID="btnreport" runat="server" Text="Get Report" OnClick="btnreport_Click" />
                  </div>
             </div>
             </div>
             </div>
    </asp:Content>
