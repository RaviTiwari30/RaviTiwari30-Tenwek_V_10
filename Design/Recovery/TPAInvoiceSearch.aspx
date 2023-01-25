
<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" 
MasterPageFile="~/DefaultHome.master" MaintainScrollPositionOnPostback="true" 
CodeFile="~/Design/Recovery/TPAInvoiceSearch.aspx.cs" Inherits="Design_Recovery_TPAInvoiceSearch" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Src="~/IEdit/IEdit.ascx" TagName="TextEditor" TagPrefix="uc2" %>
<%@ Register TagPrefix="CE" Namespace="CuteEditor" Assembly="CuteEditor" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <b>TPA Invoice Search</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"  ClientIDMode="Static" /></div>
        </div>
        <div class="POuter_Box_Inventory">

        <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-3">                         
                            <span id="SpnMRNo" class="pull-left">UHID</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">
                            <asp:TextBox ID="txtMRNo" runat="server" CssClass="ItDoseTextinputText" Width="144px" ClientIDMode="Static" TabIndex="1" /> 



                        </div>                        
                        <div class="col-md-3">                          
                             <span id="SpnIPNo" class="pull-left">IP No</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left"> 
                              <asp:TextBox ID="txtIPNo" runat="server" CssClass="ItDoseTextinputText" Width="144px" ClientIDMode="Static"  TabIndex="2"/>
                        </div>
                        <div class="col-md-3">                           
                            <span id="Span4" class="pull-left">Invoice No</span>                       
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">         
                             <asp:TextBox ID="txtInvNo" runat="server" CssClass="ItDoseTextinputText" Width="144px" ClientIDMode="Static"  TabIndex="3" />                   
                        </div>
                    </div>
                </div>
             <%--   <div class="col-md-1"></div>--%>
            </div>

        <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-3">                         
                            <span id="Span1" class="pull-left">Date From</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">
                              <asp:TextBox ID="FrmDate" runat="server" ToolTip="Click To Select From Date" Width="144px" TabIndex="4" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="cdFrom" runat="server" TargetControlID="FrmDate" Format="dd-MMM-yyyy" ClearTime="true"></cc1:CalendarExtender>
                        </div>                        
                        <div class="col-md-3">                          
                             <span id="Span2" class="pull-left">To Date</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left"> 
                            <asp:TextBox ID="ToDate" runat="server" ToolTip="Click To Select To Date" Width="144px" TabIndex="5" ClientIDMode="Static"></asp:TextBox> 
                            <cc1:CalendarExtender ID="cdTo" runat="server" TargetControlID="ToDate" Format="dd-MMM-yyyy" ClearTime="true"></cc1:CalendarExtender> 
                        </div>
                        <div class="col-md-3">                           
                            <span id="Span3" class="pull-left">Panel</span>                       
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">         
                              <asp:DropDownList ID="ddlPanelCompany" runat="server" ClientIDMode="Static"  TabIndex="6"></asp:DropDownList>            
                        </div>
                    </div>
                </div>
           <%--     <div class="col-md-1"></div>--%>
            </div>

        <div class="row" style="text-align:center" >
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-24">                         
                               <input type="button" id="btnSearch" class="ItDoseButton" value="Search" tabindex="7" />
                        </div>
                        
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>        
        
        <div class="POuter_Box_Inventory">
			<div class="row">
                <div style="text-align:center" class="col-md-6">							
						</div>
						<div style="text-align:center" class="col-md-6">
								 <button type="button" style="width:25px;height:25px;margin-left:5px;float:left"  class="circle badge-warning"></button>
							 <b style="margin-top:5px;margin-left:5px;float:left">Pending</b> 
						</div>
						 <div style="text-align:center" class="col-md-6">						
                             <button type="button" style="width:25px;height:25px;margin-left:5px;float:left"  class="circle badge-avilable"></button>
							 <b style="margin-top:5px;margin-left:5px;float:left">Acknowledgement Received</b> 
						</div>
						 <div style="text-align:center" class="col-md-6">							
						</div>
						
			 </div>	
            
            <div style="overflow:auto;max-height:200px;" id="divInvoiceDetail" class="col-md-24  CustomfixedHeader"></div>
            	
		</div>            
        <%-- <div class="POuter_Box_Inventory">
         	
         </div>--%>   
                                 
        <div id="divDocuments" class="modal fade " >
        <div class="modal-dialog">
            <div class="modal-content" style="background-color:white;width:1100px;height:auto;">
                <div class="modal-header">
                    <h4 class="modal-title">  TPA Documents Detail</h4>
                    <b><span id="Span7" class="ItDoseLblError"></span></b>  
                </div>
                    <div class="modal-body">
                    <div class="row">
                                <div class="col-md-1"></div>
                                <div class="col-md-22">
                                    <div class="row">                     
                                        <div class="col-md-24">                                              
                                            <div style="overflow:auto;max-height:200px;" id="divFileUpload" class="col-md-24  CustomfixedHeader"></div>        
                                        </div>
                        
                                    </div>
                                </div>
                                <div class="col-md-1"></div>
                    </div>
                     <div class="row">
                                <div class="col-md-1"></div>
                                <div class="col-md-22">
                                    <div class="row">                     
                                        <div class="col-md-24">                                                                                                              
                                            <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Text="Save" Width="60px" />
                                             &nbsp;<asp:Button ID="BtnCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" Width="60px" />
                                        </div>                        
                                    </div>
                                </div>
                                <div class="col-md-1"></div>
                    </div>
                    </div>
                    <div class="modal-footer">                       
                         <button type="button"  data-dismiss="divDocuments" >Close</button>
                    </div>
            </div>
        </div>
    </div>
             
        </div>
        <script type="text/javascript">
            function abc() {
                $('#divDocuments').showModel();
            }
            $(document).ready(function () {
                $('#FrmDate').change(function () {
                    ChkDate();
                });
                $('#ToDate').change(function () {
                    ChkDate();
                });
                
            });
            function ChkDate() {
                $.ajax({
                    url: "../common/CommonService.asmx/CompareDate",
                    data: '{DateFrom:"' + $('#FrmDate').val() + '",DateTo:"' + $('#ToDate').val() + '"}',
                    type: "POST",
                    async: true,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        var data = mydata.d;
                        if (data == false) {
                            $('#lblMsg').text('To date can not be less than from date!');
                            $('#btnSearch').attr('disabled', 'disabled');
                        }
                        else {
                            $('#lblMsg').text('');
                            $('#btnSearch').removeAttr('disabled');
                        }
                    }
                });
            }
            $('#btnSearch').on("click", function (e) {
                SearchInvoice();
            });

            function SearchInvoice() {
                $("#divInvoiceDetail").empty();
                $.ajax({
                    url: "Services/InvoiceSearch.asmx/TPAInvoiceSearch",
                    data: '{FromDate:"' + $('#FrmDate').val() + '",ToDate:"' + $('#ToDate').val() + '",MRNo:"' + $("#txtMRNo").val() + '",IPNo:"' + $('#txtIPNo').val() + '",InvNo:"' + $('#txtInvNo').val() + '",PanelID:"' + $('#ddlPanelCompany').val() + '"}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        if (mydata.d != null && mydata.d != "0") {
                            InvData = $.parseJSON(mydata.d);
                            if (InvData.length > 0) {
                                var HtmlOutput = $("#InvScript").parseTemplate(InvData);
                                $("#divInvoiceDetail").html(HtmlOutput);
                                $("#divInvoiceDetail").show();
                            }
                            else {
                                $("#divInvoiceDetail").hide();
                            }
                        }
                        else {
                            $("#divInvoiceDetail").empty();
                            $("#divInvoiceDetail").hide();
                        }
                    },
                    error: function (xhr, status) {
                        $("#divInvoiceDetail").empty();
                        $("#divInvoiceDetail").hide();
                    }
                });
            }

            function ViewModel(rowID) {
                $('#lblMsg').text('');
                var RAID = $(rowID).closest('tr').find('#tdRAID').text();
                $('#divDocuments').showModel();
            }


        </script>

      <script type="text/html" id="InvScript">
        <table cellspacing="5" cellpadding="5" class="yui" rules="all" border="1" style="border-collapse:collapse;width:100%; text-align:left;">
		    <tr>            
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Received</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Invoice Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Invoice No</th>               
                <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Created By</th>                
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Panel</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:80px; display:none;">IsActive</th>	                	  
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;text-align:center;">View</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;text-align:center;">Reject</th>	  
              		                				                                        	            
		    </tr>
		    <#       
		    var dataLength=InvData.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;               
		    for(var j=0;j<dataLength;j++)
		    {
                objRow=InvData[j];
                                
		    #>
				<tr
                     <#
	                    if((InvData[j].IsRecUploaded =="No"))
						  {#>   style="background-color:#f89406" <#} 
							else 
								 {#>  style="background-color:#3CB371" <#} 
							
							 #>
                    
                    >                                          
                    <td class="GridViewLabItemStyle" style="width:50px;text-align:center;" ><#=(j+1)#></td>
					<td class="GridViewLabItemStyle" style="width:80px;text-align:left;" ><#=objRow.IsRecUploaded#></td>
                    <td class="GridViewLabItemStyle" style="width:130px;text-align:left; "><#=objRow.TPAInvDate#></td>
                    <td class="GridViewLabItemStyle" style="width:130px;text-align:left; "><#=objRow.TPAInvNo#></td>                      
                    <td class="GridViewLabItemStyle" style="width:130px;text-align:left; "><#=objRow.TPAInvCreatedBy#></td>                            
					<td class="GridViewLabItemStyle" style="width:200px;text-align:left; "><#=objRow.Panel#></td> 
                    <td class="GridViewLabItemStyle" style="width:80px;text-align:left; display:none;"><#=objRow.Panel#></td> 
                    <td class="GridViewLabItemStyle" style="width:60px;text-align:left;text-align:center; ">
                        <img id="imgView" src="../../Images/view.GIF" style="cursor:pointer" onclick="ViewModel(this)" alt="" />
                    </td>                        
                    <td class="GridViewLabItemStyle" style="width:60px;text-align:left;text-align:center; ">
                        <img id="imgReject" src="../../Images/Delete.gif" style="cursor:pointer"  alt=""
                             <#if( objRow.IsReject=='false'){#>
								   disabled="disabled" <#} 
								  #>
                            
                             />


                    </td> 
                    
                                         
                </tr>            
                
		    <#}        
		    #>                   
	    </table>    
    </script>
        


    <script id="tb_DentalProcedure" type="text/html">
    <table  cellspacing="0" rules="all" border="1" id="tb_grdDentalProcedure" clientidmode="Static"
    style="border-collapse:collapse;"  class="GridViewStyle">
        <tr id="Tr1">        
           <th class="GridViewHeaderStyle" scope="col" style="width:220px;text-align:right;" colspan="2">TPA Invoice Re</th>
		</tr>

		<tr id="Header">        
           <th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.</th>
           <th class="GridViewHeaderStyle" scope="col" style="width:300px;">Status</th>
		</tr>
        <#       
        var dataLength=ViewDetail.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
      var DepositedAmount=0;                    
        for(var j=0;j<dataLength;j++)
        {       
        objRow = ViewDetail[j];
        #>
           
                 <tr id="<#=j+1#>">                                                                                                                                          
                   <td id="tdSno" style="width:20px;" class="GridViewLabItemStyle"><#=j+1#></td>                                                        
                   <td id="tdFileUpload" style="width:300px;"><asp:FileUpload ID="FileUpload1" runat="server" ClientIDMode="Static" /></td>            
                 </tr>           
        <#}       
        #>     
            
            
              
    </table>    
    </script>


</asp:Content>
