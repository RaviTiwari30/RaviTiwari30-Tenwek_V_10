
<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" 
MasterPageFile="~/DefaultHome.master" MaintainScrollPositionOnPostback="true" 
CodeFile="~/Design/Recovery/RecoveryAction.aspx.cs" Inherits="Design_Recovery_RecoveryAction" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
   
    <script type="text/javascript">
 $(document).ready(function () {
            $('#tableRecoveryBill tr').click(function () {
                $('#tableRecoveryBill tr').css('background-color', 'Red');
                $(this).css('background-color', 'Green');
 
            });
        });
     $(document).ready(function () {
        getPanelGroup();   
        getPanel($.trim($("#ddlPanelGroup").val()));   
        $('#txtFromDate').change(function () {
            ChkDate();
        });
        $('#txtToDate').change(function () {
            ChkDate();
        });  

        $('#ddlProcess').change(function(){
               GetTargetDate();       
        });
        $('#ddlQuery').change(function(){
               GetTargetDate();       
        });  
            $('#rdoResolved').click(function() {
                if ($("#rdoResolved").is(':checked')) {
                    $("#tblQueryExpDate").hide();
                    $('#tblQueryRemark').show(); 
                    $("#lblQueryRemark").text('Resolved Remark :');
                    $("#SpnQueryStatus").text('');
                }
            });
             $('#rdoPending').click(function() {
                if ($("#rdoPending").is(':checked')) {
                  $("#tblQueryExpDate").show();
                  $('#tblQueryRemark').show(); 
                  $("#lblQueryRemark").text('Extension Remark :');
                  $("#SpnQueryStatus").text('');
                }
            });
        
        $('#chkQuery').click(function() {
            if ($(this).is(':checked')) {
                 if(confirm("Are you sure?"))
                 {
                     $("#ddlProcess").hide();
                      $("#ddlQuery").show();
                     $("#spntxt").text('Query');
                     getQuery();
                 }
                 else
                 {
                    $('#chkQuery').attr('checked', false);                 
                 }
            }    
            
            if (!$(this).is(':checked')) {
               $("#ddlQuery").hide();
               $("#ddlProcess").show();
               $("#spntxt").text('Process');
                getInvoiceProcess();                
            }  
           GetTargetDate();       
        });
                
            $("#btnSave").bind("click", function () {
                $("#spnErrorMsg").text('');
                $('#btnSave').attr('disabled', 'disabled');
                if ($("#btnSave").val() == "Save") {                 
                    SaveActionPlan();
                }
            });           
            $("#btnUpdateQuery").bind("click", function () {
                $("#spnErrorMsg").text('');
                $('#btnUpdateQuery').attr('disabled', 'disabled');
                if ($("#btnUpdateQuery").val() == "Save") {                 
                    SaveQueryRemark();
                }
            });          
            
            $("#btnreport").bind("click", function () {
             window.open('data:application/vnd.ms-excel,' + encodeURIComponent( $('div[id$=div_RecoveryBillSearch]').html()));
            });      
    });
       
  
    
      function ChkDate() {
        $.ajax({
            url: "../common/CommonService.asmx/CompareDate",
            data: '{DateFrom:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtFromDate').value + '",DateTo:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtToDate').value  + '"}',
            type: "POST",
            async: true,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (mydata) {
                var data = mydata.d;
                if (data == false) {
                    $("#spnErrorMsg").text('To date can not be less than from date!');
                    $('#btnReport').attr('disabled', 'disabled');
                }
                else {
                     $("#spnErrorMsg").text('');
                    $('#btnReport').removeAttr('disabled');
                }
            }
        });

    }
        
        $(function () {           
        $("#btnsearch").bind("click", function () {
                $("#spnErrorMsg").text('');
                getRecoveryBill();
            });
        });

        $(document).ready(function(){
            $(".getpanel").change(function(){
                getPanel($.trim($("#ddlPanelGroup").val()));
            });
        });

    function getRecoveryBill()
        {
         $('#div_RecoveryBillSearch,#div_RecoveryBillDetail,#div_RecoveryBillDeatilHeader').hide();
            var chkDisp = "";
           if ($('#chkDisDate').is(":checked"))
           chkDisp = "1";
            else 
           chkDisp = "0";
            $.ajax({                                                                         
                url: "Services/Recovery_Action.asmx/SearchRecoveryBill",
                data: '{InvoiceNo:"' + $.trim($("#txtInvoiceNo").val()) + '",IPNo:"' + $.trim($("#txtIPNo").val()) + '",PanelGroup:"' + $.trim($("#ddlPanelGroup").val()) + '",PanelID:"' + $.trim($("#ddlPanel").val()) + '",DispatchDate:"' + $.trim($("#txtDispatchDate").val()) + '",DocketNo:"' + $.trim($("#txtDocketNo").val()) + '",FromDate:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtFromDate').value + '",ToDate:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtToDate').value + '",chkDisp:"' + chkDisp + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                RecoveryBillDetail = $.parseJSON(result.d);
                    if (RecoveryBillDetail != "0") {
                        var RecoveryBillOutPut = $('#tb_RecoveryBillSearch').parseTemplate(RecoveryBillDetail);
                        $('#div_RecoveryBillSearch').html(RecoveryBillOutPut);
                        $('#div_RecoveryBillSearch').show();
                    }
                    else {
                        $("#spnErrorMsg").text('Record Not Exist');
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
     
     
     
    function getPanelGroup() {
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
                    for (i = 0; i < PanelGroupData.length; i++) {
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
                    for (i = 0; i < PanelData.length; i++) {
                        $("#ddlPanel").append($("<option></option>").val(PanelData[i].PanelID).html(PanelData[i].Company_Name));
                    }                        
                }
            },
            error: function (xhr, status) {
                $("#ddlPanel").attr("disabled", false);
            }
        });
    }
        
     function getInvoiceProcess() {
                $("#ddlProcess option").remove();
//                $('#ddlProcess').attr("disabled", true); 
                var TPAInvNo = $('#lblTPAInvNo').text();
                var IPNo = $('#lblIPNo').text();
                $.ajax({
                    url: "Services/Recovery_Action.asmx/getInvoiceProcess",
                    data: '{TPAInvNo:"' + TPAInvNo + '",IPNo:"' + IPNo + '"}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (result) {
                       var ProcessData = $.parseJSON(result.d);
                        if (ProcessData == "0") {  
                            $("#ddlProcess").append($("<option></option>").val("0").html("---No Process Found---"));
                            $("#btnSave").attr("disabled", false);
                            $('#spnTargetDate').text('');
                        }
                        else {
                            for (i = 0; i < ProcessData.length; i++) {
                                $("#ddlProcess").append($("<option></option>").val(ProcessData[i].ProcessID).html(ProcessData[i].Name));
                            }
                              $("#btnSave").removeAttr('disabled');
                        }
                    },
                    error: function (xhr, status) {
                        $("#btnSave").attr("disabled", false);
                    }
                });
            }
            
            function getQuery() {
                $("#ddlQuery option").remove();
                $.ajax({
                    url: "Services/Recovery_Action.asmx/getQuery",
                    data: '{}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (result) {
                        QueryData = $.parseJSON(result.d);
                        if (QueryData == "0") {
                            $("#ddlQuery").append($("<option></option>").val("0").html("---No Data Found---"));
                             $("#btnSave").attr("disabled", false);
                        }
                        else {
                            for (i = 0; i < QueryData.length; i++) {
                                $("#ddlQuery").append($("<option></option>").val(QueryData[i].QueryID).html(QueryData[i].Name));
                            }
                               $("#btnSave").removeAttr('disabled');
                        }
                    },
                    error: function (xhr, status) {
                        $("#btnSave").attr("disabled", false);
                    }
                });
            }
           
           function GetTargetDate() {
           var TPAInvNo = $('#lblTPAInvNo').text();
           var IPNo = $('#lblIPNo').text();
           var Type=""
           
            if ($("#chkQuery").is(':checked'))
                    Type="Query";
                    else
                        Type="Process";
                        
            $.ajax({
                url: "Services/Recovery_Action.asmx/GetTargetDate",
                data: '{ProcessID:"' + $("#ddlProcess").val() + '",QueryID:"' + $("#ddlQuery").val() + '",TPAInvNo:"' + TPAInvNo + '",IPNo:"' + IPNo + '",Type:"' + Type + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = $.parseJSON(mydata.d);
                    if (data != "0") {                  
                        $('#spnTargetDate').text(data[0].TargetDate);
//                        $('#txtTo').val(data[0].ToDate);
//                        $('#rdbActive :radio[value="' + data[0].IsActive + '"]').attr("checked", "checked");
                    }
                    else
                    {
                    $('#spnTargetDate').text('');
                    }
                }
            });
        }
        
           function Item() {
            var chkQuery = "";
            if ($("#chkQuery").is(':checked')) 
                chkQuery = "1";
            else
                chkQuery = "0";
           
           var chkClose = "";
            if ($("#chkClose").is(':checked')) 
                chkClose = "1";
            else
                chkClose = "0";
                
                
            var data = new Array();
            var objItem = new Object();
            objItem.TPAInvNo= $('#lblTPAInvNo').text();
            objItem.IPNo= $('#lblIPNo').text();
            objItem.BillNo= $('#lblBillNo').text();
            objItem.ProcessID = $('#ddlProcess').val();
            objItem.QueryID = $('#ddlQuery').val();
            objItem.IsTPAQuery = chkQuery;
            objItem.TargetDate= $('#spnTargetDate').text();    
            objItem.ExpectedDate= document.getElementById('ctl00_ContentPlaceHolder1_txtExpectedDate').value          
            objItem.UserRemark=$.trim($("#txtRemark").val()) 
            objItem.IsClose = chkClose;                                                                       
            data.push(objItem);
            return data;
        }        
        
         function SaveActionPlan() {
                var resultItem = Item();
                $.ajax({
                    url: "Services/Recovery_Action.asmx/SaveActionPlan",
                      data: JSON.stringify({ Data: resultItem }),
                        type: "Post",
                        contentType: "application/json; charset=utf-8",
                        timeout: "120000",
                        dataType: "json",
                        success: function (result) {
                        var data = $.parseJSON(result.d);
                        if (data == "1") {
                            ClosePopUp();
                            getRecoveryBill();
                            $("#spnErrorMsg").text('Record Saved Successfully');   
                            $("#btnSave").removeAttr('disabled');
                            
                        }
                        else if (data == "2") {
                            $("#spnErrorMsg").text('Process Already Exist...');
                            $("#btnSave").attr("disabled", false);
                        }
                        else {
                               $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                        }
                    },
                    error: function (xhr, status) {
                               $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                    }
                });           
        }
        
          function QueryResolveItem() {
          var Type=""
          if ($("#rdoResolved").is(':checked')) {    
               Type="Res";
             }
          else   if ($("#rdoPending").is(':checked')) {    
               Type="Pen";
             }
          
            var data = new Array();
            var objItem = new Object();
            objItem.TPAInvNo= $('#SpnTPAInvNo').text();
            objItem.IPNo= $('#SpnIPNo').text();
            objItem.RAID= $('#SpnRAID').text();                    
            objItem.UserRemark =$.trim($("#txtQueryRemark").val());    
            objItem.ExpectedDate = document.getElementById('ctl00_ContentPlaceHolder1_txtQExpDate').value    
            objItem.Type = Type;  
                                                                                
            data.push(objItem);
            return data;
        }        
        
         function SaveQueryRemark() {         
            if (validateItem() == true) {
                var resultItem = QueryResolveItem();
                    $.ajax({
                        url: "Services/Recovery_Action.asmx/SaveQueryRemark",
                          data: JSON.stringify({ Data: resultItem }),
                            type: "Post",
                            contentType: "application/json; charset=utf-8",
                            timeout: "120000",
                            dataType: "json",
                            success: function (result) {
                            var data = $.parseJSON(result.d);
                            if (data == "1") {
                                CloseQPopUp();
                                getRecoveryBill();
                                $("#spnErrorMsg").text('Record Saved Successfully');   
                                $("#btnUpdateQuery").removeAttr('disabled');
                                $("#SpnQueryStatus").text('');
                                document.getElementById('ctl00_ContentPlaceHolder1_txtQExpDate').value="";
                            }
                            else {
                                   $("#SpnQueryStatus").text('Error occurred, Please contact administrator');
                            }
                        },
                        error: function (xhr, status) {
                                   $("#SpnQueryStatus").text('Error occurred, Please contact administrator');
                        }
                    });     
              }
              else {
                $('#btnUpdateQuery').removeAttr('disabled');
            }
               
        }
   
      function validateItem() {

            if($('input[name=rdochk]:checked').length<=0)   {      
                   $("#SpnQueryStatus").text('Kindly Select Any Radio Button...');
                    $("#btnUpdateQuery").removeAttr('disabled');
               return false;                 
            }   
            
            if ($("#rdoPending").is(':checked')) {             
               if (document.getElementById('ctl00_ContentPlaceHolder1_txtQExpDate').value  == "") {
                    $("#SpnQueryStatus").text('Select Next Expected Date to Resolve Query');
                    $('#txtQExpDate').focus();
                    return false;
                }      
                
                if ($.trim( $('#txtQueryRemark').val()) == "") {
                    $("#SpnQueryStatus").text('Enter Reason for Extension');
                    $('#txtQueryRemark').focus();
                    return false;
                }                                                                        
            }
            
             if ($("#rdoResolved").is(':checked')) {    
                if ($.trim( $('#txtQueryRemark').val()) == "") {
                    $("#SpnQueryStatus").text('Enter Resolved Remark');
                    $('#txtQueryRemark').focus();
                    return false;
                }   
             }
                
          return true;
        }
           
  function ShowPopUp(rowID) {
            $("#spnErrorMsg").text(''); 
            var RAID=$(rowID).closest('tr').find('#tdRAID').text();
            if(RAID=="")
            {
                $('#txtRemark').val(''); 
                $('#txtExpectedDate').val('');                 
                $('#lblTPAInvNo').text($(rowID).closest('tr').find('#tdTPAInvNo').text());
                $('#lblIPNo').text($(rowID).closest('tr').find('#tdIPNo').text());
                $('#lblTPAInvDate').text($(rowID).closest('tr').find('#tdTPAInvoiceDate').text());
                $('#lblDispatchDate').text($(rowID).closest('tr').find('#tdDispatchDate').text());
                $('#lblBillNo').text($(rowID).closest('tr').find('#tdBillNo').text());
                $('#lblBillAmt').text($(rowID).closest('tr').find('#tdBillAmt').text());
                $('#lblPName').text($(rowID).closest('tr').find('#tdPName').text());
                $('#lblPanel').text($(rowID).closest('tr').find('#tdPanel').text());
                $('#lblDocketNo').text($(rowID).closest('tr').find('#tdDocketNo').text());
                $("#spntxt").text('Process');
                $("#ddlProcess").show();
                $("#ddlQuery").hide();                                                             
                $('#chkQuery').removeAttr('checked');    
                $('#chkClose').removeAttr('checked');            
                getInvoiceProcess();            
                getQuery();    
                GetTargetDate();                                             
                GetPreviousComment();
                $find('mpChange').show();
            }
            else
            {  
                document.getElementById('ctl00_ContentPlaceHolder1_txtQExpDate').value="";            
                $('#txtQueryRemark').val('');  
                $("#SpnQueryStatus").text('');
                $("#tblQueryExpDate").hide();
                $('#tblQueryRemark').hide();                   
                $('#rdoResolved').removeAttr('checked');  
                $('#rdoPending').removeAttr('checked');  
                $('#SpnTPAInvNo').text($(rowID).closest('tr').find('#tdTPAInvNo').text());
                $('#SpnIPNo').text($(rowID).closest('tr').find('#tdIPNo').text());
                $('#SpnTPAInvDate').text($(rowID).closest('tr').find('#tdTPAInvoiceDate').text());   
                $('#SpnRAID').text($(rowID).closest('tr').find('#tdRAID').text());    
                $('#SpnQuery').text($(rowID).closest('tr').find('#tdQuery').text());                                   
                $('#SpnQueryDate').text($(rowID).closest('tr').find('#tdQueryDate').text());
                $('#SpnQueryUser').text($(rowID).closest('tr').find('#tdQueryUser').text());
                $('#SpnQueryRemark').text($(rowID).closest('tr').find('#tdQueryRemark').text());                                                      
                $find('mpChangeQ').show();
            }
        }
    function ClosePopUp() {
            $find('mpChange').hide();
        }
   
    function GetPreviousComment() {

            $('#div_ActionDetail,#div_ActionDeatilHeader').hide();
            $("#spnErrorMsg").text('');
            var TPAInvNo = $('#lblTPAInvNo').text();
            var IPNo = $('#lblIPNo').text();
            $.ajax({
                url: "Services/Recovery_Action.asmx/GetPreviousComment",
                data: '{InvoiceNo:"' + TPAInvNo + '",IPNo:"' + IPNo + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    Comment = $.parseJSON(result.d);
                  if (Comment != "0") {
                        var CommentOutPut = $('#tb_ActionDetail').parseTemplate(Comment);
                        $('#div_ActionDetail').html(CommentOutPut);
                        $('#div_ActionDetail').show();
                        $('#div_ActionDeatilHeader').show();
                    }
                    else {
                          $("#spnErrorMsg").text('No Pervious Comment');
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        
          function CloseQPopUp() {
            $find('mpChangeQ').hide();
        } 
        
        </script>
    
        
       <script id="tb_RecoveryBillSearch" type="text/html">
        <table  id="tableRecoveryBill" border="1" style="width:1280px;border-collapse:collapse;">       
		        <tr>
			        <th class="GridViewHeaderStyle" scope="col" style="width:60px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Invoice No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:50px;">IP No</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Patient Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Panel</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:110px">Invoice Date</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Dispatch Date</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;display:none;">Bill No</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none;">Bill Amount</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none;">Docket No</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none;">RAID</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;display:none;">Query</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none;">Query Date</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;display:none;">Query User</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:200px;display:none;">Query Remark</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Select</th>            
		        </tr>
                   
            <#
             var dataLength=RecoveryBillDetail.length;        
             var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = RecoveryBillDetail[j];
                #>          
		        <tr id="tr_<#=(j+1)#>">
			        <td class="GridViewLabItemStyle"  style="width:60px;" id="tdSNo"><#=(j+1)#></td>
                    <td class="GridViewLabItemStyle"  style="width:150px;" id="tdTPAInvNo"><#=objRow.TPAInvNo#></td>
                    <td class="GridViewLabItemStyle"  style="width:50px;" id="tdIPNo"><#=objRow.IPNo#></td>
                    <td class="GridViewLabItemStyle"  style="width:150px;Text-align:left;" id="tdPName"><#=objRow.PName#></td>
                    <td class="GridViewLabItemStyle"  style="width:200px;Text-align:left;" id="tdPanel"><#=objRow.Panel#></td>
                    <td class="GridViewLabItemStyle"  style="width:110px" id="tdTPAInvoiceDate"><#=objRow.TPAInvoiceDate#></td>
                    <td class="GridViewLabItemStyle"  style="width:100px;" id="tdDispatchDate"><#=objRow.DispatchDate#></td>   
                    <td class="GridViewLabItemStyle"  style="width:130px;display:none;" id="tdBillNo"><#=objRow.BillNo#></td>
                    <td class="GridViewLabItemStyle"  style="width:100px;display:none;" id="tdBillAmt"><#=objRow.BillAmt#></td>       
                    <td class="GridViewLabItemStyle"  style="width:100px;display:none;" id="tdDocketNo"><#=objRow.DocketNo#></td>    
                    <td class="GridViewLabItemStyle"  style="width:60px;display:none;" id="tdRAID"><#=objRow.RAID#></td>   
                    <td class="GridViewLabItemStyle"  style="width:150px;display:none;" id="tdQuery"><#=objRow.Query#></td>  
                    <td class="GridViewLabItemStyle"  style="width:100px;display:none;" id="tdQueryDate"><#=objRow.QueryDate#></td>    
                    <td class="GridViewLabItemStyle"  style="width:130px;display:none;" id="tdQueryUser"><#=objRow.QueryUser#></td>  
                    <td class="GridViewLabItemStyle"  style="width:200px;display:none;" id="tdQueryRemark"><#=objRow.QueryRemark#></td>              
                    <td class="GridViewLabItemStyle"  style="width:70px;"> 
                        <img src="../../Images/edit.png" style="cursor:pointer" onclick="ShowPopUp(this)"  />                  
                    </td>   
		        </tr>
            <#}#>            
         </table>    
    </script>
        
     <script id="tb_ActionDetail" type="text/html">
        <table  id="ActionDetails" border="1" style="width:876px;border-collapse:collapse;">       
		        <tr>
			        <th class="GridViewHeaderStyle" scope="col" style="width:50px;">S.No.</th>
			        <th class="GridViewHeaderStyle" scope="col" style="width:30px;display:none;">ID</th>
			        <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Query</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Process/Query</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Expected Date</th>    
                    <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Remark</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:120px;">CreatedBy</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Created Date</th>                  
                    <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Reject</th>            
		        </tr>
                   
            <#
             var dataLength=Comment.length;        
             var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = Comment[j];
                #>          
		        <tr id="tr1">
			        <td class="GridViewLabItemStyle"  style="width:50px;" ><#=(j+1)#></td>
			        <td class="GridViewLabItemStyle"  style="width:30px;display:none;" id="tdID"><#=objRow.ID#></td>
			        <td class="GridViewLabItemStyle"  style="width:40px;Text-align:left;" id="tdQuery"><#=objRow.IsTPAQuery#></td>
                    <td class="GridViewLabItemStyle"  style="width:120px;Text-align:left;" id="tdProcess"><#=objRow.GroupRemark#></td>
                    <td class="GridViewLabItemStyle"  style="width:100px;" id="tdExpectedDate"><#=objRow.ExpectedDate#></td>
                    <td class="GridViewLabItemStyle"  style="width:180px;Text-align:left;" id="tdUserRemark"><#=objRow.UserRemark#></td>
                    <td class="GridViewLabItemStyle"  style="width:120px;" id="tdCreatedBy"><#=objRow.CreatedBy#></td>
                    <td class="GridViewLabItemStyle"  style="width:150px;" id="tdCreatedDate"><#=objRow.CreatedDate#></td>                  
                    <td class="GridViewLabItemStyle"  style="width:40px;"> 
                        <img src="../../Images/Delete.gif" style="cursor:pointer" />                  
                    </td>   
		        </tr>
            <#}#>            
         </table>    
    </script>
    
    
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
               <b>Recovery Action</b>&nbsp;<br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
                </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center">

               <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-3">                         
                            <span id="Span3" class="pull-left">Invoice No</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">
                              <input type="text" id="txtInvoiceNo" tabindex="3"  title="Enter Invoice No" class="ItDoseTextinputText"   />
                        </div>                        
                        <div class="col-md-3">                          
                             <span id="Span4" class="pull-left">IPD No</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left"> 
                             <input type="text" id="txtIPNo" tabindex="3"  title="Enter IP No" class="ItDoseTextinputText"   />
                        </div>
                        <div class="col-md-3">                           
                            <span id="Span5" class="pull-left">UHID</span>                       
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">         
                              <input type="text" id="Text1" tabindex="3"  title="Enter UHID" class="ItDoseTextinputText"   />         
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-3">                         
                            <span id="Span6" class="pull-left">Panel Group</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">
                              <select id="ddlPanelGroup" tabindex="1" style="width: 225px" title="Select Panel"  class="getpanel"></select>
                        </div>                        
                        <div class="col-md-3">                          
                             <span id="Span7" class="pull-left">Panel</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left"> 
                             <select id="ddlPanel" tabindex="2" style="width: 225px" title="Select Panel"></select>
                        </div>
                        <div class="col-md-3">                           
                            <span id="Span8" class="pull-left">Docket No</span>                       
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">         
                              <input type="text" id="txtDocketNo" tabindex="3"  title="Enter Docket No" class="ItDoseTextinputText" />           
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

        <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-3">                         
                            <span id="Span9" class="pull-left">From Date</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">
                             <asp:TextBox ID="txtFromDate" runat="server" ToolTip="Click To Select Date" CssClass="ItDoseTextinputText" />
                            <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" /> 
                        </div>                        
                        <div class="col-md-3">                          
                             <span id="Span10" class="pull-left">To Date</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left"> 
                              <asp:TextBox ID="txtToDate" runat="server" ToolTip="Click To Select Date" />
                            <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy" />
                        </div>
                        <div class="col-md-3">      
                            <input id="chkDisDate" type="checkbox"/>                        
                            <span id="Span11" class="pull-left">Dispatch Date  </span>                                                                                                                                                                                                                                                                                                                                                                   
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">         
                              <asp:TextBox ID="txtDispatchDate" runat="server" ToolTip="Click To Select Date" CssClass="ItDoseTextinputText" />
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />         
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>


              
            </div>
        </div>
        
        
     
        <div class="POuter_Box_Inventory" style="text-align: center;">

                <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-12"  style="text-align:right">                         
                           <input type="button" id="btnsearch" value="Search" class="ItDoseButton" />
                        </div>
                        <div class="col-md-12"  style="text-align:left"> 
                           <input type="button" id="btnreport" value="Report" class="ItDoseButton" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>



            
            &nbsp;
            
        </div> 
        
         <div class="POuter_Box_Inventory" style="text-align: center;display:none;" id="div_RecoveryBillSearch">            
        </div>       
       
       
        
   </div>      
        
     <%--   Action Plan Start--%>
          <asp:Button ID="btnhide" runat="server" style="display:none;"></asp:Button>
     <cc1:ModalPopupExtender ID="mpChange" BehaviorID="mpChange" runat="server" DropShadow="true" TargetControlID="btnhide" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlComment" X="40" Y="40">
     </cc1:ModalPopupExtender>     



        <asp:Panel ID="pnlComment" runat="server">         
        <div style="margin: 0px;background-color: #eaf3fd;border: solid 1px Green;display: inline-block;padding: 1px 1px 1px 1px;margin: 0px 10px 3px 10px;width:900px;">
            <div class="Purchaseheader">
                <table width="890">
                    <tr>
                        <td style="text-align:left;">
                            <b>Recovery Action Plan</b>
                        </td>
                        <td  style="text-align:right;">
                            <em ><span style="font-size: 7.5pt">Press esc or click<img alt="" src="../../Images/Delete.gif" style="cursor:pointer" onclick="ClosePopUp()"/>to close</span></em>                            
                         </td>  
                     </tr>
                 </table>                
            </div>                 
            <div class="POuter_Box_Inventory" style="width:897px;text-align:center;">
                <b><span id="spnMsg" class="ItDoseLblError"></span></b>                     
                <table  style="border-collapse:collapse;">                                           
                    <tr>
                        <td style="text-align:right;width:200px;">Invoice No :&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="lblTPAInvNo"></span></td>
                         <td style="text-align:right;width:200px;">Invoice Date :&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="lblTPAInvDate"></span></td>
                        <td style="text-align:right;width:200px;">Dispatch Date :&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="lblDispatchDate"></span></td>
                    </tr>                    
                    <tr>
                     <td style="text-align:right;width:200px;">IP No :&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="lblIPNo"></span></td>
                        <td style="text-align:right;width:200px;">Bill No :&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="lblBillNo"></span></td>
                        <td style="text-align:right;width:200px;">Bill Amount :&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="lblBillAmt"></span></td>
                    </tr>   
                    
                     <tr>
                     <td style="text-align:right;width:200px;">Patient Name :&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="lblPName"></span></td>
                        <td style="text-align:right;width:200px;">Panel :&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="lblPanel"></span></td>
                        <td style="text-align:right;width:200px;">Docket No :&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="lblDocketNo"></span></td>
                    </tr>                
                </table>   
            </div>                          
           
           
            <div class="POuter_Box_Inventory" style="text-align: center;width:897px;" id="div1">
            <div class="Purchaseheader">
                Save Remark
            </div>           
        </div>             
            <div class="POuter_Box_Inventory" style="width:897px;text-align:center;">
                <b><span id="Span1" class="ItDoseLblError"></span></b>                     
                <table  style="border-collapse:collapse;">                                           
                    <tr>
                        <td style="text-align:right;width:200px;">
                        <span id="spntxt"></span>:&nbsp;
                        </td>
                        <td style="text-align:left;width:200px;">
                           <select id="ddlProcess" tabindex="2" style="width: 150px" title="Select Process"></select>
                           <select id="ddlQuery" tabindex="2" style="width: 150px" title="Select Process"></select>
                            <span style="color: red; font-size: 10px;" class="shat">*</span>
                        </td>
                         <td style="text-align:right;width:200px;">Expected Date :&nbsp;</td>
                        <td style="text-align:left;width:200px;">
                             <asp:TextBox ID="txtExpectedDate" runat="server" ToolTip="Click To Select Date" CssClass="ItDoseTextinputText" />
                            <cc1:CalendarExtender ID="CalExpDate" runat="server" TargetControlID="txtExpectedDate"  
                            Format="dd-MMM-yyyy"  />
                            
                        
                        </td>
                        <td style="text-align:right;width:150px;">IsQuery :&nbsp;</td>
                        <td style="text-align:left;width:250px;">
                         <input id="chkQuery" type="checkbox" />
                        </td>
                    </tr>     
                    <tr>
                        <td style="text-align:right;width:200px;vertical-align:top;">Remark :&nbsp;</td>
                        <td style="text-align:left;width:400px;vertical-align:top;" colspan="3">
                           <input type="text" id="txtRemark" tabindex="3" maxlength="250" title="Enter User Remark" style="width:350px;height:50px;" />
                         <span style="color: red; font-size: 10px;" class="shat">*</span>
                        </td>      
                        <td style="text-align:right;width:150px;vertical-align:top;">Target Date :&nbsp;</td>
                        <td style="text-align:left;width:250px;vertical-align:top;">
                          <span id="spnTargetDate"></span>
                        </td>                 

                    </tr> 
                    
                    <tr>
                        <td style="text-align:right;width:200px;">&nbsp;</td>
                        <td style="text-align:left;width:600px;" colspan="5">
                         <input type="button" id="btnSave" value="Save" tabindex="5" class="ItDoseButton" />&nbsp;
                         <input id="chkClose" type="checkbox" /><span style="font-weight:bold; color:Red;">Close Current Process</span>
                        </td>                                                
                    </tr> 
                    
                    
                                        
                             
                </table>   
            </div>                          
           
           
           
         <div class="POuter_Box_Inventory" style="text-align: center;display:none;width:897px;" id="div_ActionDeatilHeader">
            <div class="Purchaseheader">
                Previous Remark
            </div>           
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;display:none; overflow:scroll; height:200px;width:897px;" id="div_ActionDetail">            
        </div>
           
          </div>  
          
          
          
     
              
         
               
         
    </asp:Panel> 
        
    <%--   Action Plan END--%>
        
        
        
        
        <%--   Action Plan Start--%>
          <asp:Button ID="btnhideqmp" runat="server" style="display:none;"></asp:Button>
     <cc1:ModalPopupExtender ID="mpChangeQ" BehaviorID="mpChangeQ" runat="server" DropShadow="true" TargetControlID="btnhideqmp" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlQuery" X="40" Y="40">
     </cc1:ModalPopupExtender>     



        <asp:Panel ID="pnlQuery" runat="server">         
        <div style="margin: 0px;background-color: #eaf3fd;border: solid 1px Green;display: inline-block;padding: 1px 1px 1px 1px;margin: 0px 10px 3px 10px;width:900px;">
            <div class="Purchaseheader">
                <table width="890">
                    <tr>
                        <td style="text-align:left;">
                            <b>Resolve Query</b>
                        </td>
                        <td  style="text-align:right;">
                            <em ><span style="font-size: 7.5pt">Press esc or click<img alt="" src="../../Images/Delete.gif" style="cursor:pointer" onclick="CloseQPopUp()"/>to close</span></em>                            
                         </td>  
                     </tr>
                 </table>                
            </div>                 
            <div class="POuter_Box_Inventory" style="width:897px;text-align:center;">
                <b><span id="Span2" class="ItDoseLblError"></span></b>                     
                <table  style="border-collapse:collapse;">                                           
                    <tr>
                        <td style="text-align:right;width:200px;">Invoice No :&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="SpnTPAInvNo"></span></td>
                         <td style="text-align:right;width:200px;">Invoice Date :&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="SpnTPAInvDate"></span></td>
                        <td style="text-align:right;width:200px;">IP No :&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="SpnIPNo"></span></td>
                    </tr>                    
                    <tr>
                     <td style="text-align:right;width:200px;">Query :&nbsp;</td>
                        <td style="text-align:left;width:200px;">
                        <span id="SpnRAID" style="display:none;"></span>    
                          <span id="SpnQuery"></span>                      
                     </td>
                        <td style="text-align:right;width:200px;">Query Date :&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="SpnQueryDate"></span></td>
                        <td style="text-align:right;width:200px;">Query By :&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="SpnQueryUser"></span></td>
                    </tr>   
                    
                     <tr>
                     <td style="text-align:right;width:200px;">Query Remark :&nbsp;</td>
                     <td style="text-align:left;width:1000px;" colspan="5"><span id="SpnQueryRemark"></span></td>                       
                    </tr>                
                </table>   
            </div>                          
           
           
            <div class="POuter_Box_Inventory" style="text-align: center;width:897px;" id="div2">
            <div class="Purchaseheader">
                Save Remark
            </div>           
        </div>             
            <div class="POuter_Box_Inventory" style="width:897px;text-align:center;">
                <b><span id="SpnQueryStatus" class="ItDoseLblError"></span></b>         
                 <div style="text-align: center">
                    <input id="rdoResolved" type="radio" name="rdochk" value="Resolved" />Resolved
                    <input id="rdoPending" type="radio" name="rdochk" value="Pending" />Pending    
                </div>   
                
                 <table id="tblQueryExpDate" style="border-collapse:collapse; display:none;">                                           
                     
                    <tr>
                       <td style="text-align:right;width:200px;vertical-align:top;">Expected Date :&nbsp;</td>
                        <td style="text-align:left;width:800px;vertical-align:top;" colspan="5">
                            <asp:TextBox ID="txtQExpDate" runat="server" ToolTip="Click To Select Date" CssClass="ItDoseTextinputText" ReadOnly="true" />
                            <cc1:CalendarExtender ID="CalQExpDate" runat="server" TargetControlID="txtQExpDate"  
                            Format="dd-MMM-yyyy"  />
                         <span style="color: red; font-size: 10px;" class="shat">*</span>
                        </td>  
                    </tr> 
                    </table>
                         
                <table id="tblQueryRemark"  style="border-collapse:collapse;">                                           
                     
                    <tr>
                        <td style="text-align:right;width:200px;vertical-align:top;"><span id="lblQueryRemark"></span>&nbsp;</td>
                        <td style="text-align:left;width:800px;vertical-align:top;" colspan="5">
                           <input type="text" id="txtQueryRemark" tabindex="3" maxlength="250" title="Enter Resolved Remark" style="width:650px;height:50px;" />
                         <span style="color: red; font-size: 10px;" class="shat">*</span>
                        </td>      
                         

                    </tr> 
                    
                    <tr>
                        <td style="text-align:right;width:200px;">&nbsp;</td>
                        <td style="text-align:left;width:800px;" colspan="5">
                         <input type="button" id="btnUpdateQuery" value="Save" tabindex="5" class="ItDoseButton" />
                        </td>                                                
                    </tr>                                                                                 
                             
                </table>   
            </div>                          
           
           
           
            <div class="POuter_Box_Inventory" style="text-align: center;display:none;width:897px;" id="div3">
                <div class="Purchaseheader">
                    Previous Remark
                </div>           
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;display:none; overflow:scroll; height:200px;width:897px;" id="div4">            
            </div>
           
          </div>               
         
    </asp:Panel> 
        
    <%--   Action Plan END--%>
    
    
    
       
            
</asp:Content>
