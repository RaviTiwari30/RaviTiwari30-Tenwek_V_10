<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="TPAQueryMaster.aspx.cs" Inherits="Design_Recovery_TPAQueryMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Panel Query Master</b>&nbsp;<br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
            <div style="text-align: center">
                <input id="rdoNew" type="radio" name="Con" value="New" checked="checked">New
           <input id="rdoEdit" type="radio" name="Con" value="Edit">Edit    
            </div>

        </div>
        <div class="POuter_Box_Inventory">
            <table style="width: 100%; border-collapse: collapse">              
                <tr>
                    <td style="width: 15%; text-align: right">Query :&nbsp;
                        
                    </td>
                    <td style="width: 30%; text-align: left">
                        <input type="text" id="txtQuery" tabindex="3" maxlength="100" title="Enter Query Name" style="width: 250px"  class="requiredField"  />
                    </td>
                    <td style="width: 15%; text-align: right">&nbsp;
                    </td>
                    <td style="width: 45%; text-align: left">
                       &nbsp;
                    </td>
                </tr>
                <tr class="trCondition" style="display:none">
                    <td style="width: 15%; text-align: right;" >Condition :&nbsp;
                    </td>
                    <td style="width: 30%; text-align: left;" >
                       <input id="rdoActive" type="radio" name="ActiveCon" value="1" checked="checked">Active
                        <input id="rdoDeActive" type="radio" name="ActiveCon" value="0">DeActive  
                         <input id="rdoBoth" type="radio" name="ActiveCon" value="2">Both 

                    </td>
                  <td style="width: 15%; text-align: right"> &nbsp;
                    </td>
                    <td style="width: 45%; text-align: left">
                        &nbsp;
                    </td>
                </tr>
                
            </table>

        </div>

        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" id="btnSave" value="Save" tabindex="5" class="ItDoseButton" />
        </div>
         <div class="POuter_Box_Inventory" style="text-align: center">
         <div id="ItemOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
             <input type="button" id="btnUpdate" value="Update" class="ItDoseButton" style="display:none"/>
             </div>
    </div>

    <script id="tb_QuerySearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdQuerySearch"
    style="width:950px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>                   
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Query</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">Query ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Active</th>
		</tr>
        <#       
        var dataLength=ItemData.length;  
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = ItemData[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle"><#=j+1#></td>                             
                    <td class="GridViewLabItemStyle" id="tdQuery" style="width:200px;">
                       <input type="text" maxlength="100" style="width:280px" value="<#=objRow.Query#>" id="txtQuery" onkeyup="CheckItem(this);" onkeypress="CheckItem(this);"  class="requiredField" />
                       <span id="spnQueryName" onpaste="return false" style="display:none" ><#=objRow.Query#> </span>
                       <span id="spnTypeCon"  style="display:none" /></td>
                    <td class="GridViewLabItemStyle" id="tdQueryID" style="width:140px;display:none"><#=objRow.QueryID#></td>                    
                    <td class="GridViewLabItemStyle" id="tdActive"  style="width:60px;">
                   <input type="radio" id="rdotdActive" name="tdActive_<#=j+1#>" value="1"
                      onclick="chkActiveCon(this)"    <#if(objRow.IsActive=="1"){#> 
                        checked="checked"  <#} #> />Yes                         
                         <input type="radio" id="rdotdDeActive" name="tdActive_<#=j+1#>" value="0"
                        onclick="chkActiveCon(this)" <#if(objRow.IsActive=="0"){#> 
                        checked="checked"  <#} #>  />No                                               
                        <span id="spnActive" style="display:none"   ><#=objRow.IsActive#></span>
                         <span id="spnActiveCon" style="display:none"   />
                    </td>
                    </tr>           
        <#}#>                     
     </table>    
    </script>
    <script type="text/javascript">
        function CheckItem(rowid) {
            $("#spnErrorMsg").text('');
            var txtQuery = $.trim($(rowid).closest('tr').find('#txtQuery').val());
            var spnQueryName = $.trim($(rowid).closest('tr').find('#spnQueryName').html());                      
            if ((txtQuery != spnQueryName) ) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnTypeCon').html('1'));
            }
            else if (($.trim($(rowid).closest('tr').find('#spnActiveCon').html()) == "1")) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnTypeCon').html('0'));
            }
            else {
                $.trim($(rowid).closest('tr').find('#spnTypeCon').html('0'));
                $(rowid).closest('tr').css("background-color", "transparent");
            }                        
        }
      
        function chkActiveCon(rowid) {
            $("#spnErrorMsg").text('');
            var rdotdActive = $(rowid).closest('tr').find('#tdActive input[type=radio]:checked').val();
            var spnActive = $.trim($(rowid).closest('tr').find('#spnActive').html());          
            if (rdotdActive != spnActive) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnActiveCon').html('1'));
            }
            else if (($.trim($(rowid).closest('tr').find('#spnTypeCon').html()) == "1")) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnActiveCon').html('0'));
            }
            else {
                $.trim($(rowid).closest('tr').find('#spnActiveCon').html('0'));
                $(rowid).closest('tr').css("background-color", "transparent");
            }
        }
       
        $(function () {
            $("#btnUpdate").bind("click", function () {
                $('#btnUpdate').attr('disabled', 'disabled');
                if (validateQueryUpdate() == true) {
                    var resultQueryUpdate = QueryUpdate();
                    $.ajax({
                        url: "Services/TPA_Query_Master.asmx/UpdateQueries",
                        data: JSON.stringify({ Data: resultQueryUpdate }),
                        type: "Post",
                        async: false,
                        contentType: "application/json; charset=utf-8",
                        timeout: "120000",
                        dataType: "json",
                        success: function (result) {
                            if (result.d == "1") {
                            $("#spnErrorMsg").text('Record Updated Successfully');
                            $('#txtQuery').val('');
                                $('#btnUpdate').removeAttr('disabled');
                                $('#ItemOutput').html('');
                                $('#ItemOutput,#btnUpdate').hide();
                                $('#rdoActive').prop('checked', 'checked');
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
                else {
                    $('#btnUpdate').removeAttr('disabled');
                }
            });
            
        });
        function validateQueryUpdate() {
            var con = 0; var tableCon = 1;
            $("#tb_grdQuerySearch tr").each(function () {
                var id = $(this).attr("id");
                var $rowid = $(this).closest("tr");              
                if (id != "Header") {
                    if (($.trim($rowid.find('#spnTypeCon').html()) == "1") || ($.trim($rowid.find('#spnActiveCon').html()) == "1")) {
                        if ($.trim($rowid.find("#txtQuery").val()) == "") {
                            $("#spnErrorMsg").text('Please Enter Query Name');
                            $rowid.find("#txtQuery").focus();
                            con = 1;
                            return false;
                        }
                        tableCon += 1;                      
                    }
                }
                
            });
            if (con == "1")
                return false;
            if (tableCon == "1") {
                $("#spnErrorMsg").text('Please Change Query Name OR Active Condition');
                return false;
            }           
            return true;
        }
        function QueryUpdate() {
            if ($('#tb_grdQuerySearch tr').length > 0) {
                var con = 0;
               // $('#btnUpdate').prop('disabled', 'disabled');
                var dataItem = new Array();
                var ObjItem = new Object();
                $("#tb_grdQuerySearch tr").each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");                  
                    if (id != "Header") {
                        if (($.trim($rowid.find('#spnTypeCon').html()) == "1") || ($.trim($rowid.find('#spnActiveCon').html()) == "1")) {
                            ObjItem.Query = encodeURIComponent($.trim($rowid.find("#txtQuery").val()));
                            ObjItem.QueryID = $.trim($rowid.find("#tdQueryID").text());
                            if ($rowid.find("#rdotdActive").is(':checked'))
                                ObjItem.IsActive = "1";
                            else
                                ObjItem.IsActive = "0";
                           
                            dataItem.push(ObjItem);
                            ObjItem = new Object();
                        }
                    }

                });
                return dataItem;
            }
        }
        function hideAllDetail() {
            $('#ItemOutput').html('');
            $('#ItemOutput,#btnUpdate').hide();
          
            $("#spnErrorMsg").text('');
            $('#txtQuery').val('');
        }

        $(function () {
            if ($("#rdoNew").is(':checked')) {
                $("#btnSave").val('Save');
            }
            if ($("#rdoEdit").is(':checked')) {
                $("#btnSave").val('Search');
            }

            $("#rdoNew").bind("click", function () {
                $("#btnSave").val('Save');
                $('#btnSave').removeAttr('disabled');
                $(".trCondition").hide();
                hideAllDetail();
            });
            $("#rdoEdit").bind("click", function () {
                $("#btnSave").val('Search');
                $('#btnSave').removeAttr('disabled');
                $(".trCondition").show();
                hideAllDetail();
            });
            $("#btnSave").bind("click", function () {
                $("#spnErrorMsg").text('');
                $('#btnSave').attr('disabled', 'disabled');
                if ($("#btnSave").val() == "Search") {
                    bindQuery();
                }
                else if ($("#btnSave").val() == "Save") {                    
                    SaveQuery();
                }
            });
        });

        function Query() {
            var data = new Array();
            var objItem = new Object();
            objItem.Query = encodeURIComponent($.trim($('#txtQuery').val()));
            data.push(objItem);
            return data;
        }
        function validateQuery() {
            
            if ($("#txtQuery").val() == "") {
                $("#spnErrorMsg").text('Please Enter Query Name');
                $("#txtQuery").focus();
                return false;
            }
            return true;
        }
        function bindQuery() {
            $("#spnErrorMsg").text('');
            if ($.trim($("#txtQuery").val()) == "") {
                $("#spnErrorMsg").text('Please Enter Query Name');
                $('#btnSave').removeAttr('disabled');
                $("#txtQuery").focus();
                return;
            }
            var type = "";
            if ($("#rdoActive").is(':checked')) 
                type = "1";
            else if ($("#rdoDeActive").is(':checked')) 
                type = "0";
            else 
                type = "2";
            $.ajax({
      
             url: "Services/TPA_Query_Master.asmx/LoadQueries",
                data: '{Query:"' + $("#txtQuery").val() + '",Type:"' + type + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    if (result != "0") {
                        ItemData = $.parseJSON(result.d);
                        if (ItemData != null) {
                            var output = $('#tb_QuerySearch').parseTemplate(ItemData);
                            $('#ItemOutput').html(output);
                            $('#ItemOutput,#btnUpdate').show();
                            $('#btnSave').removeAttr('disabled');
                        }
                    }
                    else {
                        $('#ItemOutput').html();
                        $('#ItemOutput,#btnUpdate').hide();
                         $("#spnErrorMsg").text('Record Not Exist');
                            $('#txtQuery').focus();
                        $('#btnSave').removeAttr('disabled');
                    }
                },
                error: function (xhr, status) {
                    $('#ItemOutput').html();
                    $('#ItemOutput').hide();
                }
            });
        }
        
       function SaveQuery() {
            if (validateQuery() == true) {
                $.ajax({
                    url: "Services/TPA_Query_Master.asmx/SaveQuery",
                    data: '{Query:"' + $("#txtQuery").val() + '"}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                success: function (result) {
                        if (result.d == "1") {
                            $("#spnErrorMsg").text('Record Saved Successfully');
                            $('#txtQuery').val('');
                            $("#btnSave").removeAttr('disabled');
                        }
                        else if (result.d == "2") {
                            $("#spnErrorMsg").text('Query Already Exist');
                            $('#txtQuery').focus();
                            $("#btnSave").removeAttr('disabled');
                        }                       
                        else {
                         $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                            $('#txtQuery').focus();
                        }
                },
                error: function (xhr, status) {
                    $('#ItemOutput').html();
                    $('#ItemOutput').hide();
                }
            });
            }
            else {
                $('#btnSave').removeAttr('disabled');
            }
        }
        
    </script>
</asp:Content>

