<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PanelDocumentVerification.aspx.cs" Inherits="Design_OPD_PanelDocumentVerification" Title="Panel Discount Search" %>
       
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
                     
      <asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
         <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
    
<script  type='text/javascript' src="../../Scripts/PDFVIEWER/pdf.js"></script>
<script  type='text/javascript' src="../../Scripts/PDFVIEWER/pdfViewer.js"></script>

          <style type="text/css">

.highlighted {
    background: LightGreen;
}
.highlightedSub {
    background: LightYellow;
}
</style>s

    <script type="text/javascript">
        var previewFile = function (e) {
            viewPdfDocument('pdfViwer', URL.createObjectURL(e.target.files[0]), 1, function (response) { });
        };
    </script>


    <script type="text/javascript" >

        $(document).ready(function () {
            getPanelGroup();
            getPanel($.trim($("#ddlPanelGroup").val()));


            $(".getpanel").change(function () {
                getPanel($.trim($("#ddlPanelGroup").val()));
            });

        });

        function getPanelGroup() {
            $("#spnErrorMsg").text(''); 
            $("#ddlPanelGroup option").remove();
            $.ajax({
                url: "../common/CommonService.asmx/getPanelGroup",
                data: '{ }',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    PanelGroupData = $.parseJSON(result.d);
                    if (PanelGroupData.length == 0) {
                        $("#ddlPanelGroup").append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        $("#ddlPanelGroup").append($("<option></option>").val("ALL").html("ALL"));
                        for (i = 1; i < PanelGroupData.length; i++) {
                            $("#ddlPanelGroup").append($("<option></option>").val(PanelGroupData[i].PanelGroup).html(PanelGroupData[i].PanelGroup));
                        }
                    }
                },
                error: function (xhr, status) {
                    $("#ddlPanelGroup").attr("disabled", false);
                }
            });
        }

        function getPanel(PnlGroup) {
            $("#spnErrorMsg").text(''); 
            $("#ddlPanel option").remove();
            $.ajax({
                url: "../common/CommonService.asmx/getPanel",
                data: '{PanelGroup:"' + PnlGroup + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    PanelData = $.parseJSON(result.d);
                    if (PanelData.length == 0) {
                        $("#ddlPanel").append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        $("#ddlPanel").append($("<option></option>").val("0").html("ALL"));
                        for (i = 1; i < PanelData.length; i++) {
                            $("#ddlPanel").append($("<option></option>").val(PanelData[i].PanelID).html(PanelData[i].Company_Name));
                        }
                    }
                },
                error: function (xhr, status) {
                    $("#ddlPanel").attr("disabled", false);
                }
            });
        }


        function searchOPD() {
            $.blockUI({ message: 'Please Wait.....\n<img src="../../Images/loadingAnim.gif" />' });
                   $("#spnErrorMsg").text(''); 
            $.ajax({
                    type: "POST",
                    url: "../common/CommonService.asmx/BindPanelPatient",
                    data: '{PatientID:"' + $("#txtPatientID").val() + '",Name:"' + $("#txtName").val() + '",PanelID:"' + $.trim($("#ddlPanel").val()) + '",FromDate:"' +   $("#txtFDSearch").val() + '",ToDate:"' + $("#txtTDSearch").val() + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    success: function (response) {
                            OPD = jQuery.parseJSON(response.d);
                            if (OPD != null) {
                                var output = $('#tb_OPD').parseTemplate(OPD);
                                $('#OPDOutput').html(output);
                                $('#OPDOutput').show();
                            }
                            else {
                                DisplayMsg('MM04', 'spnErrorMsg');
                                $('#OPDOutput').hide();
                            }
                        },
                        error: function (xhr, status) {
                            DisplayMsg('MM05', 'spnErrorMsg');
                            window.status = status + "\r\n" + xhr.responseText;

                        }

            });
            $.unblockUI();
               }

               function ShowPopUp(rowID) {
                   $("#spnErrorMsg").text('');
                   $('#SpnMRNo').text($(rowID).closest('tr').find('#tdMRNo').text());
                   $('#SpnPName').text($(rowID).closest('tr').find('#tdPName').text());
                   $('#SpnAgeSex').text($(rowID).closest('tr').find('#tdAgeSex').text());
                //   viewPdfDocument('pdfViwer', '/his/PanelDocument/MR17000938/LLSHHI4_ReferralDocument.pdf', 1, function (response) { });
                   getTnxDetail();
                 //  getDocumentDetail();
                   $find('mpViewDocument').show();
               }

               function ClosePopUp() {
                   $find('mpViewDocument').hide();
                   $('#pdfViwer').hide();
                   $('#ImgDoc').show();
                   $('#ImgDoc').attr('src', '../../Images/NoImage.jpg')
                   $('#div_left_sub2').hide();
                   $('#tb_Document tr').remove();
               }

               function getTnxDetail() {
                   $('#div_left_sub1').hide();
                   $("#spnMsg").text('');
                   var PatientID = $('#SpnMRNo').text();

                   $.ajax({
                       url: "../common/CommonService.asmx/getTnxDetail",
                       data: '{PatientID:"' + PatientID + '",FromDate:"' + $("#txtFDSearch").val() + '",ToDate:"' + $("#txtTDSearch").val() + '"}',
                       type: "POST",
                       contentType: "application/json; charset=utf-8",
                       timeout: 120000,
                       async: false,
                       dataType: "json",
                       success: function (result) {
                           TnxDetail = $.parseJSON(result.d);
                           if (TnxDetail != "0") {
                               var TnxDetailOutPut = $('#td_TnxDetail').parseTemplate(TnxDetail);
                               $('#div_left_sub1').html(TnxDetailOutPut);
                               $('#div_left_sub1').show();
                           }
                           else if (TnxDetail == "0") {
                               var TnxDetailOutPut = $('#tb_Document').parseTemplate(TnxDetail);
                               $('#div_left_sub1').html(TnxDetailOutPut);
                               $("#spnMsg").text('No Record Found');
                               $('#div_left_sub1').show();
                           }
                       },
                       error: function (xhr, status) {
                           window.status = status + "\r\n" + xhr.responseText;
                       }
                   });
               }

               function ShowDocumentList(rowID) {
                   $("#spnMsg").text('');
                   var TID = $(rowID).closest('tr').find('#tdTransactionID').text();
                   $("#SpnTnxID").text(TID);

                   $(rowID).closest('tr').addClass("highlight");
                   jQuery(rowID).closest('tr').parent().find('tr').removeClass("highlighted");
                   jQuery(rowID).closest('tr').addClass("highlighted");
                   var selected = $(rowID).closest('tr').hasClass("highlighted");                  
                   if (!selected)
                       jQuery(rowID).closest('tr').addClass("nonhighlighted");

                   var DocumentType = "1";
                   getDocumentDetail(TID, DocumentType);

               }

               function getDocumentDetail(TID,DocumentType) {
                   $("#spnMsg").text('');
                   $('#div_left_sub2').hide();

                   var PatientID = $('#SpnMRNo').text();
                   var PanelID = $('#SpnPanelID').text();

                   $.ajax({
                       url: "../common/CommonService.asmx/getDocumentDetail",
                       data: '{TransactionID:"' + TID + '",Status:"'+ DocumentType +'"}',
                       type: "POST",
                       contentType: "application/json; charset=utf-8",
                       timeout: 120000,
                       async: false,
                       dataType: "json",
                       success: function (result) {
                           PanelDocumentDetail = $.parseJSON(result.d);                         
                           if (PanelDocumentDetail != "0") {
                               var DocumentOutPut = $('#tb_Document').parseTemplate(PanelDocumentDetail);
                               $('#div_left_sub2').html(DocumentOutPut);
                               $('#div_left_sub2').show();
                           }
                           else if (PanelDocumentDetail == "0") {                        
                               var DocumentOutPut = $('#tb_Document').parseTemplate(PanelDocumentDetail);
                               $('#div_left_sub2').html(DocumentOutPut);
                               $("#spnMsg").text('No Record Found');
                               $('#div_left_sub2').show();
                           }
                       },
                       error: function (xhr, status) {
                           window.status = status + "\r\n" + xhr.responseText;
                       }
                   });
               }

               function DisplayDocument(rowID) {
                   $("#spnMsg").text('');
                   var FilePath = $(rowID).closest('tr').find('#tdFilePath').text();
                   var ID = $(rowID).closest('tr').find('#tdID').text();

                   jQuery(rowID).closest('tr').parent().find('tr').removeClass("highlightedSub");
                   jQuery(rowID).closest('tr').addClass("highlightedSub");
                   var selected = $(rowID).closest('tr').hasClass("highlightedSub");
                   if (!selected)
                       jQuery(rowID).closest('tr').addClass("highlightedSub");

                   var FileExtn = $(rowID).closest('tr').find('#tdFileExtn').text()

                   if (FileExtn == ".pdf") {
                       viewPdfDocument('pdfViwer', FilePath, 1, function (response) { });
                       $('#ImgDoc').hide();
                       $('#pdfViwer').show();
                   }
                   else {
                       $('#ImgDoc').show();
                       $('#ImgDoc').attr('src', FilePath);
                       $('#pdfViwer').hide();
                   }

               }

               function chkDocumentType() {
                   var DocumentType = "1";
                   var TID = $("#SpnTnxID").text();
                   if (jQuery("#rdoActive").is(':checked'))                       
                       DocumentType="1";
                   else if (jQuery("#rdoInActive").is(':checked'))
                       DocumentType = "0";
                   else if (jQuery("#rdoAll").is(':checked'))
                       DocumentType = "All";

                   getDocumentDetail(TID, DocumentType);
               }

        </script>
       <div id="Pbody_box_inventory" >
       <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
     <div class="POuter_Box_Inventory" style="text-align:center;">
       
     
   
        <b>Panel Document Verification</b>
     <br/>                      
           <span id="spnErrorMsg" class="ItDoseLblError"></span>
      </div>
   
    
    
    <div class="POuter_Box_Inventory" style="text-align: center; ">
    <div class="Purchaseheader" >
        Search Criteria</div>
                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                            <tr >
                                <td style="width: 20%;text-align:right" >
                                    UHID :&nbsp;
                                    </td>
                                <td style="width: 30%; text-align: left;">
                                    <asp:TextBox ID="txtPatientID" runat="server" Width="149px" TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                                </td>
                                <td style="width: 20%;text-align:right" >
                                    Name :&nbsp;
                                </td>
                                <td style="width: 30%; text-align: left;">
                                            <asp:TextBox ID="txtName" runat="server" Width="149px" TabIndex="2" ClientIDMode="Static"></asp:TextBox></td>
                            </tr>
                          
                              <tr >
                                <td style="width: 20%;text-align:right" >
                                    Panel Group :&nbsp;
                                    </td>
                                <td style="width: 30%; text-align: left;">
                                   <select id="ddlPanelGroup" tabindex="1" style="width: 100px" title="Select Panel"  class="getpanel"></select>
                                </td>
                                <td style="width: 20%;text-align:right" >
                                    Panel :&nbsp;
                                </td>
                                <td style="width: 30%; text-align: left;">
                                           <select id="ddlPanel" tabindex="1" style="width: 256px" title="Select Panel"></select></td>
                            </tr>


                              <tr >
                                <td style="width: 20%;text-align:right" >
                                    Date
                                    From :&nbsp;</td>
                                <td style="width: 30%; text-align: left;">
                                   
                                  <asp:TextBox ID="txtFDSearch" runat="server"  ToolTip="Click To Select From Date"
                            TabIndex="5" ClientIDMode="Static" Width="149px"></asp:TextBox>
                        <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="txtFDSearch" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                                    
                                      </td>
                                <td style="width: 20%;text-align:right" >
                                    To Date :&nbsp;
                                </td>
                                <td style="width: 30%; text-align: left;">
                                        
                                     <asp:TextBox ID="txtTDSearch" runat="server"  ToolTip="Click To Select From Date"
                            TabIndex="6" ClientIDMode="Static" Width="149px"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtTDSearch" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                                    
                                </td>
                            </tr>
                            <tr >
                                <td  style="width: 20%;text-align:right">
                                    </td>
                                <td style="width: 30%; text-align: left">
                                    </td>
                                <td  style="width: 20%;text-align:right">
                                </td>
                                <td style="width: 30%; text-align: left">
                                </td>
                            </tr>
                            <tr >
                                <td  style=" text-align:center" colspan="4">
                                            
                                                            <input type ="button" tabindex="7"   value="Search" class="ItDoseButton" onclick="searchOPD()" />

                                </td>
                            </tr>
                        </table>
    </div> 
     <div class="POuter_Box_Inventory" >
    <div class="Purchaseheader" >
        Search Result</div>
     
                         <div id="OPDOutput" style="max-height: 600px; overflow-x: auto;">
                        </div>
                        <br />
                       
                    
    </div>
    
    </div>  
   
   <script id="tb_OPD" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" 
    style="width:940px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">UHID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:220px;">Patient Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Age/Sex</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Contact No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">City</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:130px;">State</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Select</th>
            
		</tr>
        <#       
        var dataLength=OPD.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = OPD[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>                                               
                        <td class="GridViewLabItemStyle"  style="width:100px;" id="tdMRNo"><#=objRow.PatientID#></td>
                        <td class="GridViewLabItemStyle"  style="width:220px;" id="tdPName"><#=objRow.PName#></td>
                        <td class="GridViewLabItemStyle"  style="width:100px;" id="tdAgeSex"><#=objRow.AgeSex#></td>
                        <td class="GridViewLabItemStyle"  style="width:120px;" id="tdMobile"><#=objRow.Mobile#></td>                     
                        <td class="GridViewLabItemStyle"  style="width:120px;" id="tdcity"><#=objRow.city#></td>
                        <td class="GridViewLabItemStyle"  style="width:130px;" id="tdState"><#=objRow.State#></td>
                         <td class="GridViewLabItemStyle"  style="width:70px;"> 
                        <img src="../../Images/view.gif" style="cursor:pointer" onclick="ShowPopUp(this)"  alt="" />                  
                        </td>  
                    </tr>            
        <#}        
        #>      
     </table>    
    </script>


           <script id="Script1" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" 
    style="width:940px;border-collapse:collapse;">
		<tr id="Tr3">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">UHID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:220px;">Patient Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Age/Sex</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Contact No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">City</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:130px;">State</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Select</th>
            
		</tr>
        <#       
        var dataLength=OPD.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = OPD[j];
        #>
                    <tr id="Tr4">                            
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>                                               
                        <td class="GridViewLabItemStyle"  style="width:100px;" id="td9"><#=objRow.PatientID#></td>
                        <td class="GridViewLabItemStyle"  style="width:220px;" id="td10"><#=objRow.PName#></td>
                        <td class="GridViewLabItemStyle"  style="width:100px;" id="td11"><#=objRow.AgeSex#></td>
                        <td class="GridViewLabItemStyle"  style="width:120px;" id="td12"><#=objRow.Mobile#></td>                     
                        <td class="GridViewLabItemStyle"  style="width:120px;" id="td13"><#=objRow.city#></td>
                        <td class="GridViewLabItemStyle"  style="width:130px;" id="td14"><#=objRow.State#></td>
                         <td class="GridViewLabItemStyle"  style="width:70px;"> 
                        <img src="../../Images/view.gif" style="cursor:pointer" onclick="ShowPopUp(this)"  alt="" />                  
                        </td>  
                    </tr>            
        <#}        
        #>      
     </table>    
    </script>




          <script id="td_TnxDetail" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" 
    style="width:600px; border-collapse:collapse;">
		<tr id="Tr1">
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;"></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;text-align:left;">Visit Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:130px;text-align:left;">TypeOfTnx</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;text-align:left;">Panel</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;text-align:left;display:none;">TransactionID</th>	
            
            
		</tr>
        <#       
        var dataLength=TnxDetail.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = TnxDetail[j];
        #>
                    <tr id="Tr2">   
                        <td class="GridViewLabItemStyle"  style="width:20px;"> 
                        <img src="../../Images/view.gif" style="cursor:pointer" onclick="ShowDocumentList(this)"  alt="" />                  
                        </td>                           
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>                                                                   
                        <td class="GridViewLabItemStyle"  style="width:150px; text-align:left;" id="tdVisitDate1"><#=objRow.VisitDate#></td>
                        <td class="GridViewLabItemStyle"  style="width:130px; text-align:left;" id="tdTypeOfTnx1"><#=objRow.TypeOfTnx#></td>
                        <td class="GridViewLabItemStyle"  style="width:150px; text-align:left;" id="tdPanel1"><#=objRow.Panel#></td>
                        <td class="GridViewLabItemStyle"  style="width:50px; text-align:left; display:none;" id="tdTransactionID"><#=objRow.TransactionID#></td>
                         
                    </tr>            
        <#}        
        #>      
     </table>    
    </script>


 <script id="tb_Document" type="text/html">
        <table  id="table_DocumentDetail" border="1" style="width:440px;  border-collapse:collapse;">   
                <tr>
                    <th class="GridViewHeaderStyle" scope="col" style="width:40px;">View</th> 
                    <th class="GridViewHeaderStyle" scope="col" style="width:30px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:20px;Text-align:left;display:none;">ID</th> 
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;Text-align:left;">FileName</th>                       
                    <th class="GridViewHeaderStyle" scope="col" style="width:50px;Text-align:left;display:none;">FilePath</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:50px;Text-align:left;display:none;">FileExtn</th>   
                    <th class="GridViewHeaderStyle" scope="col" style="width:70px;Text-align:left;display:none;">TID</th>     
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;Text-align:left;">Date</th>
                                                                                                                      
		        </tr>            		                          
            <#
                 var dataLength=PanelDocumentDetail.length;        
                 var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = PanelDocumentDetail[j];
                #>          
		        <tr id="tr_<#=(j+1)#>">
                      <td class="GridViewStyleMIS"  style="width:40px;"> 
                        <img src="../../Images/view.gif" style="cursor:pointer" onclick="DisplayDocument(this)"  alt="" />                  
                    </td>      
			        <td class="GridViewStyleMIS"  style="width:30px;" id="tdSNo"><#=(j+1)#></td>  
                    <td class="GridViewStyleMIS"  style="width:20px;display:none;" id="tdID"><#=objRow.ID#></td>
                    <td class="GridViewStyleMIS"  style="width:130px;Text-align:left;" id="tdFileName"><#=objRow.FileName#></td>      
                    <td class="GridViewStyleMIS"  style="width:50px;Text-align:left;display:none;" id="tdFilePath"><#=objRow.FilePath#></td>
                    <td class="GridViewStyleMIS"  style="width:50px;Text-align:left;display:none;" id="tdFileExtn"><#=objRow.FileExtn#></td>  
                    <td class="GridViewStyleMIS"  style="width:70px;Text-align:left;display:none;" id="tdTID"><#=objRow.TID#></td> 
                    <td class="GridViewStyleMIS"  style="width:130px;Text-align:left;" id="tdDate"><#=objRow.Date#></td> 
                                                                                    
		        </tr>		        
            <#}#>                         
         </table>                            
          
    </script>


          <asp:Button ID="btnhide" runat="server" style="display:none;"></asp:Button>
     <cc1:ModalPopupExtender ID="mpViewDocument" BehaviorID="mpViewDocument" runat="server" DropShadow="true" TargetControlID="btnhide" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlViewDocument" X="40" Y="40">
     </cc1:ModalPopupExtender>     



        <asp:Panel ID="pnlViewDocument" runat="server" style="display:none">         
        <div style="margin: 0px;background-color: #eaf3fd;border: solid 1px Green;display: inline-block;padding: 1px 1px 1px 1px;margin: 0px 10px 3px 10px;width:1200px;">
            <div class="Purchaseheader">
                <table width="1200">
                    <tr>
                        <td style="text-align:left;">
                            <b>Patient Detail</b>
                        </td>
                        <td  style="text-align:right;">
                            <em ><span style="font-size: 7.5pt">Press esc or click<img alt="" src="../../Images/Delete.gif" style="cursor:pointer" onclick="ClosePopUp()"/>to close</span></em>                            
                         </td>  
                     </tr>
                 </table>                
            </div>                 
            <div class="POuter_Box_Inventory" style="width:1200px;text-align:center;">
                <b><span id="spnMsg" class="ItDoseLblError"></span></b>                     
                <table  style="border-collapse:collapse;">                                           
                                  
                    <tr>
                     <td style="text-align:right;width:100px;">UHID :&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="SpnMRNo"></span>
                            <span id="SpnTID" style="display:none;"></span>
                        </td>
                        <td style="text-align:right;width:120px;">Patient Name :&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="SpnPName"></span></td>

                         <td style="text-align:right;width:80px;">Age/Sex :&nbsp;</td>
                        <td style="text-align:left;width:250px;"><span id="SpnAgeSex"></span></td>
    
                    </tr>   
                    
                   
                    
                 
                </table>   
                  
            </div>                          
           
           
            <div class="POuter_Box_Inventory" style="text-align: center;width:1200px;" id="div1">
            <div class="Purchaseheader">
               Document Detail
            </div>           
        </div>             
            <div class="POuter_Box_Inventory" style="width:1200px;text-align:center;">

                <div id="div_left" style="height:500px; width:440px; float:left; overflow:auto;">

                    <div id="div_left_sub1" style="height:auto; width:auto; height:200px; overflow:auto;">

                       
                    </div>
                     <div style="text-align: center">
                <input id="rdoActive" type="radio" name="Con"  value="1"  checked="checked" onclick="chkDocumentType()" /><span id="SpnActiveDoc">Active</span>
                          <input id="rdoInActive" type="radio" name="Con" value="0" onclick="chkDocumentType()"  /><span id="SpnInActiveDoc">InActive</span>
           <input id="rdoAll" type="radio" name="Con" value="All" onclick="chkDocumentType()" /> <span id="SpnAllDoc">All</span> 
                  <span id="SpnTnxID" style="display:none;"></span>          
            </div>
                     <div id="div_left_sub2" style="height:auto; width:auto; height:280px; overflow:auto;">


                    </div>


                             </div>  

                   <div id="div_right" style="height:500px; width:750px; float:right; border:1px dotted; overflow:scroll; ">

                   <div id="pdfViwer" style="height:auto; width:100%;">

                             </div> 
                       <img id="ImgDoc" src="../../Images/NoImage.jpg" alt=""  style="width:700px;height:450px;" /> 
                       
                       
                  </div>              
                
           
            </div>                          
       
          </div>  
          
          
          
     
              
         
               
         
    </asp:Panel> 

     </asp:Content>
     
     
